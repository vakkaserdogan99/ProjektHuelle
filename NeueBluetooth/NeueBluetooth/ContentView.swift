import SwiftUI
import CoreBluetooth
import Foundation
import AVFoundation
import Accelerate
import UIKit


class AppDelegate: UIResponder, UIApplicationDelegate {
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Register background task
        registerBackgroundTask()
        return true
    }

    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "MyBackgroundTask") {
            // End the task if time expires.
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
        assert(backgroundTask != .invalid)
    }

    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        registerBackgroundTask()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        endBackgroundTask()
    }
}




// Klasse für die Bluetooth Verbindung

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    
    @Published var devices: [CBPeripheral] = []
    @Published var selectedDevice: CBPeripheral?
    @Published var isConnected: Bool = false

    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    private var audioRecorderViewModel = AudioRecorderViewModel()

    var timer: Timer?

    @Published var isLedOn: Bool = false
    @Published var brightness: Double = 0.5 // Standard Helligkeitswert
    @Published var selectedColor: Color = .white // Standard Farbe


    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }


    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == .poweredOn {
            startScanning()
        } else {
            devices = []
            isConnected = false // Nur für Test, muss eigentlich false sein!
        }
        
    }

    func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }



    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi: NSNumber) {

        let targetDeviceName = "LED Case"
        
        // Nur Geräte mit dem Namen "LED Case" werden angezeigt
        if let deviceName = peripheral.name, deviceName == targetDeviceName {
            if !devices.contains(peripheral) {
                devices.append(peripheral)
            }
        }
    }



    func connectToDevice() {
        guard let selectedDevice = selectedDevice else {
            print("No device selected.")
            return
        }
        centralManager.connect(selectedDevice, options: nil)
    }


    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral)")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        isConnected = true
        print("Discovering services...")
        self.peripheral = peripheral
    }


    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from peripheral: \(peripheral)")
        isConnected = false
        showDisconnectionAlert()
    }

// Meldung wenn die Bluetooth Verbindung abbricht

    private func showDisconnectionAlert() {
        let alert = UIAlertController(
            title: "Bluetooth Disconnected",
            message: "The Bluetooth connection has been lost.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }

        guard let services = peripheral.services else {
            print("No services discovered.")
            return
        }

        for service in services {
            print("Discovered service: \(service.uuid)")
            if service.uuid == CBUUID(string: "0000ffe0-0000-1000-8000-00805f9b34fb") {

                print("Service discovered, discovering characteristics...")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

// Aktualisierung der Bluetooth Geräte
    func refreshDeviceList() {
        devices = []
        startScanning()
    }

// Charakteristik und Service UUID Vergleich
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }

        guard let characteristics = service.characteristics else {
            print("No characteristics discovered.")
            return
        }

        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic.uuid)")
            if characteristic.uuid == CBUUID(string: "0000ffe1-0000-1000-8000-00805f9b34fb") {
                print("Characteristic discovered.")
                self.characteristic = characteristic
            }
        }
    }

// Senden von "LED ein" bzw. "LED aus" an den ESP32 gespeichert in dem Array "value"

    func sendLedStateBrightnessAndColor(isOn: Bool, brightness: Double, red: Double, green: Double, blue: Double) {
        guard let peripheral = peripheral, let characteristic = characteristic else {
            print("Peripheral or characteristic not available. Waiting for connection...")
            return
        }

        

        if peripheral.state == .connected {
            currentTask?.cancel()
            let value: [UInt8] = [isOn ? 1 : 0, 3, UInt8(brightness * 255), UInt8(red * 255), UInt8(green * 255), UInt8(blue * 255)]
            let data = Data(value)

            print("Sending LED state: \(isOn ? "ON" : "OFF"), Brightness: \(brightness)")
            print("Sending Color: R=\(red), G=\(green), B=\(blue)")
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
            
        } else {
            print("Peripheral is not connected.")
        }
    }



    

    // Muster-Methode für ESP

    @Published var currentTask: DispatchWorkItem?
    @EnvironmentObject var patternManager: PatternManager

    func sendPattern(speed: Double, version: Int, loop: Bool) {
        // Cancel the previous task if it exists
        currentTask?.cancel()
        
        var task: DispatchWorkItem!
        
        // Create a new task
        task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard let peripheral = self.peripheral, let characteristic = self.characteristic else {
                print("Peripheral or characteristic not available. Waiting for connection...")
                return
            }
            
            if peripheral.state == .connected {
                let patternIdentifier: UInt8 = 2
                let brightness: UInt8 = UInt8(self.brightness * 255)
                
                var ledPattern = patternManager.randomPattern
                if version == 31 { ledPattern = patternManager.fadePattern }
                
                if version == 11 { ledPattern = patternManager.threeSnakePattern }
                
                if version == 41 { ledPattern = patternManager.rainPattern }
                
                var loopCounter = 0
                while loopCounter < 5 {
                    if task.isCancelled { break }
                    
                    if loop {
                        for step in ledPattern {
                            if task.isCancelled { break }
                            
                            let value: [UInt8] = [patternIdentifier,
                                                  step.ledIndex1, step.led1R, step.led1G, step.led1B,
                                                  step.ledIndex2, step.led2R, step.led2G, step.led2B,
                                                  step.ledIndex3, step.led3R, step.led3G, step.led3B,
                                                  step.ledIndex4, step.led4R, step.led4G, step.led4B,
                                                  step.ledIndex5, step.led5R, step.led5G, step.led5B,
                                                  step.ledIndex6, step.led6R, step.led6G, step.led6B,
                                                  step.ledIndex7, step.led7R, step.led7G, step.led7B,
                                                  step.ledIndex8, step.led8R, step.led8G, step.led8B,
                                                  step.ledIndex9, step.led9R, step.led9G, step.led9B,
                                                  step.ledIndex10, step.led10R, step.led10G, step.led10B,
                                                  step.ledIndex11, step.led11R, step.led11G, step.led11B,
                                                  step.ledIndex12, step.led12R, step.led12G, step.led12B,
                                                  step.ledIndex13, step.led13R, step.led13G, step.led13B,
                                                  step.ledIndex14, step.led14R, step.led14G, step.led14B,
                                                  step.ledIndex15, step.led15R, step.led15G, step.led15B,
                                                  step.ledIndex16, step.led16R, step.led16G, step.led16B,
                                                  step.ledIndex17, step.led17R, step.led17G, step.led17B,
                                                  step.ledIndex18, step.led18R, step.led18G, step.led18B,
                                                  step.ledIndex19, step.led19R, step.led19G, step.led19B,
                                                  step.ledIndex20, step.led20R, step.led20G, step.led20B,
                                                  brightness]
                            
                            let data = Data(value)
                            print("Sending Pattern for LEDs, Brightness: \(brightness)%")
                            peripheral.writeValue(data, for: characteristic, type: .withResponse)
                            
                            let adjustedDuration = step.duration * (1.1 - speed)
                            Thread.sleep(forTimeInterval: adjustedDuration)
                        }
                    } else {
                        for step in ledPattern {
                            if task.isCancelled { break }
                            
                            let value: [UInt8] = [patternIdentifier,
                                                  step.ledIndex1, step.led1R, step.led1G, step.led1B,
                                                  step.ledIndex2, step.led2R, step.led2G, step.led2B,
                                                  step.ledIndex3, step.led3R, step.led3G, step.led3B,
                                                  step.ledIndex4, step.led4R, step.led4G, step.led4B,
                                                  step.ledIndex5, step.led5R, step.led5G, step.led5B,
                                                  step.ledIndex6, step.led6R, step.led6G, step.led6B,
                                                  step.ledIndex7, step.led7R, step.led7G, step.led7B,
                                                  step.ledIndex8, step.led8R, step.led8G, step.led8B,
                                                  step.ledIndex9, step.led9R, step.led9G, step.led9B,
                                                  step.ledIndex10, step.led10R, step.led10G, step.led10B,
                                                  step.ledIndex11, step.led11R, step.led11G, step.led11B,
                                                  step.ledIndex12, step.led12R, step.led12G, step.led12B,
                                                  step.ledIndex13, step.led13R, step.led13G, step.led13B,
                                                  step.ledIndex14, step.led14R, step.led14G, step.led14B,
                                                  step.ledIndex15, step.led15R, step.led15G, step.led15B,
                                                  step.ledIndex16, step.led16R, step.led16G, step.led16B,
                                                  step.ledIndex17, step.led17R, step.led17G, step.led17B,
                                                  step.ledIndex18, step.led18R, step.led18G, step.led18B,
                                                  step.ledIndex19, step.led19R, step.led19G, step.led19B,
                                                  step.ledIndex20, step.led20R, step.led20G, step.led20B,
                                                  brightness]
                            
                            let data = Data(value)
                            print("Sending Pattern for LEDs, Brightness: \(brightness)%")
                            peripheral.writeValue(data, for: characteristic, type: .withResponse)
                            
                            let adjustedDuration = step.duration * (1.1 - speed)
                            Thread.sleep(forTimeInterval: adjustedDuration)
                        }
                        
                        for step in ledPattern.reversed() {
                            if task.isCancelled { break }
                            
                            let value: [UInt8] = [patternIdentifier,
                                                  step.ledIndex1, step.led1R, step.led1G, step.led1B,
                                                  step.ledIndex2, step.led2R, step.led2G, step.led2B,
                                                  step.ledIndex3, step.led3R, step.led3G, step.led3B,
                                                  step.ledIndex4, step.led4R, step.led4G, step.led4B,
                                                  step.ledIndex5, step.led5R, step.led5G, step.led5B,
                                                  step.ledIndex6, step.led6R, step.led6G, step.led6B,
                                                  step.ledIndex7, step.led7R, step.led7G, step.led7B,
                                                  step.ledIndex8, step.led8R, step.led8G, step.led8B,
                                                  step.ledIndex9, step.led9R, step.led9G, step.led9B,
                                                  step.ledIndex10, step.led10R, step.led10G, step.led10B,
                                                  step.ledIndex11, step.led11R, step.led11G, step.led11B,
                                                  step.ledIndex12, step.led12R, step.led12G, step.led12B,
                                                  step.ledIndex13, step.led13R, step.led13G, step.led13B,
                                                  step.ledIndex14, step.led14R, step.led14G, step.led14B,
                                                  step.ledIndex15, step.led15R, step.led15G, step.led15B,
                                                  step.ledIndex16, step.led16R, step.led16G, step.led16B,
                                                  step.ledIndex17, step.led17R, step.led17G, step.led17B,
                                                  step.ledIndex18, step.led18R, step.led18G, step.led18B,
                                                  step.ledIndex19, step.led19R, step.led19G, step.led19B,
                                                  step.ledIndex20, step.led20R, step.led20G, step.led20B,
                                                  brightness]
                            
                            let data = Data(value)
                            print("Sending Pattern for LEDs, Brightness: \(brightness)%")
                            peripheral.writeValue(data, for: characteristic, type: .withResponse)
                            
                            let adjustedDuration = step.duration * (1.1 - speed)
                            Thread.sleep(forTimeInterval: adjustedDuration)
                        }
                    }
                    
                    loopCounter += 1
                }
            }
        }
        currentTask = task
        DispatchQueue.global(qos: .background).async(execute: task)
    }

    

    // Bereiche in bestimmten Farben
    
    func sendCustom(red1: Double, green1: Double, blue1: Double, red2: Double , green2: Double, blue2: Double, red3: Double, green3: Double, blue3: Double, red4: Double, green4: Double, blue4: Double, red5: Double, green5: Double, blue5: Double, brightness: Double) {

        guard let peripheral = peripheral, let characteristic = characteristic else {

            print("Peripheral or characteristic not available. Waiting for connection...")

            return

        }

        

        if peripheral.state == .connected {
            
            currentTask?.cancel()

            let patternIdentifier: UInt8 = 5 // Für Einzelne Bereiche werden verändert

            if isLedOn {
                let value: [UInt8] = [patternIdentifier, UInt8(red1 * 255), UInt8(green1 * 255), UInt8(blue1 * 255), UInt8(red2 * 255), UInt8(green2 * 255), UInt8(blue2 * 255), UInt8(red3 * 255), UInt8(green3 * 255), UInt8(blue3 * 255), UInt8(red4 * 255), UInt8(green4 * 255), UInt8(blue4 * 255), UInt8(red5 * 255), UInt8(green5 * 255), UInt8(blue5 * 255), UInt8(brightness * 255)] // Grüne Farbe

                let data = Data(value)
                
                peripheral.writeValue(data, for: characteristic, type: .withResponse)

            } else {

                print("Peripheral is not connected.")

            }
        }
    }


    // Timer-Funktion

    func startTimer() {

        // Initialisiere den Timer mit dem gewünschten Zeitabstand (z.B., alle 0.3 Sekunden)

        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(sendLiveUpdate), userInfo: nil, repeats: true)

    }



    @objc private func sendLiveUpdate() {

        // Hier rufst du deine Methode zum Senden der Live-Daten auf

        sendFrequencyAndAmplitude(frequency: audioRecorderViewModel.currentFrequency, amplitude: audioRecorderViewModel.currentAmplitude)

    }

    

    // Frequenz und Amplitude übergeben

    func sendFrequencyAndAmplitude(frequency: Double, amplitude: Double) {

        guard let peripheral = peripheral, let characteristic = characteristic else {

            print("Peripheral or characteristic not available. Waiting for connection...")

            return

        }

        

        let musicIdentifier: UInt8 = 4



        if peripheral.state == .connected {

            // Mappe die Double-Werte auf den gültigen Bereich von UInt8

            let frequencyUInt8 = UInt8(min(max(frequency, 0), 255))

            let amplitudeUInt8 = UInt8(min(max(amplitude, 0), 1) * 255)

            

            let value: [UInt8] = [musicIdentifier, frequencyUInt8, amplitudeUInt8]

            let data = Data(value)



            print("Sending Frequency: \(frequencyUInt8), Amplitude: \(amplitudeUInt8)")



            peripheral.writeValue(data, for: characteristic, type: .withResponse)

        } else {

            print("Peripheral is not connected.")

        }

    }

}



// Klasse für Mikrophon

class AudioRecorderViewModel: NSObject, ObservableObject, AVAudioRecorderDelegate {

    @Published var isMicOn: Bool = false

    @Published var isRecording = false

    @Published var audioLevel: Float = 0.0

    @Published var currentFrequency: Double = 0.0

    @Published var currentAmplitude: Double = 0.0

    

    private var audioRecorder: AVAudioRecorder?

    private var audioMeterTimer: Timer?

    private var audioEngine: AVAudioEngine?

    private var audioInputNode: AVAudioInputNode?


    override init() {

        super.init()

        setupAudioRecorder()

        setupAudioEngine()
        
        setupAudioSession() // Neuer Aufruf für die Audio-Sitzung

    }



    // Start-Stop der Aufnahme

    func toggleRecording() {

        if isRecording {

            stopRecording()

        } else {

            startRecording()

        }

    }
    
    private func setupAudioRecorder() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [
                .mixWithOthers, // Mischen mit anderen Audioquellen erlauben
                .allowBluetooth, // Nutzung von Bluetooth-Geräten erlauben
                .allowBluetoothA2DP, // Nutzung von Bluetooth A2DP für Audio
                .defaultToSpeaker // Audio standardmäßig über Lautsprecher ausgeben
            ])
            
            try session.setActive(true)
            
            print("Audio Session set up successfully.")
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }





    

    // Aufnahme Starten

    private func startRecording() {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to access documents directory.")
            return
        }
        
        let audioFilename = documentsPath.appendingPathComponent("recording.wav")
        
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            print("Microphone is on")
            isMicOn = true
            isRecording = true
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }



    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [
                .mixWithOthers, // Mischen mit anderen Audioquellen erlauben
                .allowBluetooth, // Nutzung von Bluetooth-Geräten erlauben
                .allowBluetoothA2DP, // Nutzung von Bluetooth A2DP für Audio
                .defaultToSpeaker // Audio standardmäßig über Lautsprecher ausgeben
            ])
            
            // Setzen der Audio-Eigenschaften für die Wiedergabe
            try session.setCategory(.playback, mode: .default, options: [
                .allowBluetooth, // Bluetooth-Geräte erlauben
                .allowBluetoothA2DP, // Bluetooth A2DP für Audio erlauben
                .mixWithOthers // Mischen mit anderen Audioquellen erlauben
            ])
            
            try session.setActive(true)
            
            print("Audio Session set up successfully.")
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }


    // Stoppen der Aufnahme /Zurücksetzen

    private func stopRecording() {

            audioRecorder?.stop()

            audioRecorder = nil

            print("Mic is off")

            isMicOn = false

            isRecording = false

        }





    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        audioInputNode = audioEngine?.inputNode

        let format = audioInputNode?.inputFormat(forBus: 0)
        let bufferSize = AVAudioFrameCount(format?.sampleRate ?? 44100.0)

        audioInputNode?.installTap(onBus: 0, bufferSize: bufferSize, format: format) { [weak self] (buffer, _) in
            self?.processAudio(buffer)
        }

        do {
            try audioEngine?.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }




    private func processAudio(_ buffer: AVAudioPCMBuffer) {

        guard audioRecorder?.isRecording == true else {

            return

        }



        guard let floatChannelData = buffer.floatChannelData else {

            return

        }



        let frameCount = UInt32(buffer.frameLength)

        let sampleRate = Float(buffer.format.sampleRate)

        let fft = FFT(buffer: floatChannelData[0], frameCount: frameCount, sampleRate: sampleRate)



        if let dominantFrequency = fft.calculateFrequency() {

                    DispatchQueue.main.async {

                        self.currentFrequency = dominantFrequency

                    }

                }



        let amplitude = fft.calculateAmplitude()

                DispatchQueue.main.async {

                    self.currentAmplitude = amplitude

                }

    }



    private func getDocumentsDirectory() -> URL {

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]

    }

}



// Fast Furier Transformation für die Frequenz und Amplitude

class FFT {

    

    private var buffer: UnsafeMutablePointer<Float>

    private var frameCount: UInt32

    private var sampleRate: Float



    init(buffer: UnsafeMutablePointer<Float>, frameCount: UInt32, sampleRate: Float) {

        self.buffer = buffer

        self.frameCount = frameCount

        self.sampleRate = sampleRate

    }



    func calculateFrequency() -> Double? {

        let log2n = vDSP_Length(log2(Float(frameCount)))

        let bufferSizePOT = vDSP_Length(1 << log2n)



        var real = [Float](repeating: 0.0, count: Int(bufferSizePOT / 2))

        var imaginary = [Float](repeating: 0.0, count: Int(bufferSizePOT / 2))



        var complexBuffer = DSPSplitComplex(realp: &real, imagp: &imaginary)



        let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2))



        vDSP_ctoz(UnsafePointer<DSPComplex>(OpaquePointer(buffer)), 2, &complexBuffer, 1, bufferSizePOT / 2)



        vDSP_fft_zrip(fftSetup!, &complexBuffer, 1, log2n, FFTDirection(FFT_FORWARD))



        vDSP_destroy_fftsetup(fftSetup)



        var magnitudes = [Float](repeating: 0.0, count: Int(bufferSizePOT / 2))

        vDSP_zvmags(&complexBuffer, 1, &magnitudes, 1, bufferSizePOT / 2)



        // Finden des Index des Maximums

        if let maxIndex = magnitudes.indices.max(by: { magnitudes[$0] < magnitudes[$1] }) {

            let nyquist = Float(sampleRate) / 2.0

            let currentFrequency = Float(maxIndex) * nyquist / Float(bufferSizePOT / 2)



            if currentFrequency < nyquist {

                return Double(currentFrequency)

            }

        }



        return nil

    }



    func calculateAmplitude() -> Double {

        var rms: Float = 0.0

        vDSP_rmsqv(buffer, 1, &rms, vDSP_Length(frameCount))

        return Double(rms)

    }

}

// Klasse LanguageManager um die ausgewählte Sprache zu speichern und dann anwenden zu können

class LanguageManager: ObservableObject {

    static let shared = LanguageManager()



    @Published var selectedLanguage: String {

        didSet {

            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")

        }

    }



    private init() {

        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Locale.preferredLanguages.first ?? "en"

    }
    
    func localizedString(forKey key: String) -> String {
            let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj") ?? Bundle.main.path(forResource: "en", ofType: "lproj")
            let bundle = Bundle(path: path!) ?? .main
            return bundle.localizedString(forKey: key, value: nil, table: nil)
        }

}




// ContentView (Start)

struct ContentView: View {

    @StateObject private var bluetoothManager = BluetoothManager()

    @StateObject private var patternManager = PatternManager()
    
    @StateObject private var audioRecorderViewModel = AudioRecorderViewModel()

    @State private var isMenuVisible = false

    @StateObject private var languageManager = LanguageManager.shared

    @State private var selectedTab = 0

    var body: some View {
        
        
 
        TabView (selection: $selectedTab) {
            
            // HomeView
            HomeView()
                .tabItem{
                    tabItemLabel("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            // PatternView
            PatternView()
                .tabItem {
                    tabItemLabel("Pattern", systemImage: selectedTab == 1 ? "paintpalette.fill" : "paintpalette")
                }
                .tag(1)
            
            // MusicView
            MusicView()
                .tabItem {
                    tabItemLabel("Music", systemImage: selectedTab == 2 ? "music.note" : "music.note")
                }
                .tag(2)
                .environmentObject(audioRecorderViewModel)
            
            // ShopView
            ShopView()
                .tabItem{
                    tabItemLabel("Shop", systemImage: selectedTab == 0 ? "cart.fill" : "cart")
                }
                .tag(3)
            
            // SettingsView
            SettingsView()
                .tabItem {
                    tabItemLabel("Settings", systemImage: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                }
                .tag(4)
        }
        
        .background(
            Image("background1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        
        .accentColor(.blue) // Setzt die Farbe der ausgewählten Tab-Icons auf blau
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor.white // Setzt die Farbe der nicht ausgewählten Tab-Icons auf weiß
        }
        .onOpenURL { url in
                    if url.scheme == "yourapp" {
                        switch url.host {
                        case "home":
                            selectedTab = 0
                        case "pattern":
                            selectedTab = 1
                        case "music":
                            selectedTab = 2
                        default:
                            break
                        }
                    }
                }

        .environmentObject(bluetoothManager)
        .environmentObject(languageManager)
        .environmentObject(patternManager)
    }

    // Funktion zum Erstellen von TabItem-Labels
    private func tabItemLabel(_ titleKey: LocalizedStringKey, systemImage: String) -> some View {
        return Label(titleKey, systemImage: systemImage)
            .environment(\.locale, .init(identifier: languageManager.selectedLanguage))
    }
}





struct RefreshableNavigationView<Content: View>: View {

    var content: () -> Content
    var onRefresh: () -> Void

    init(@ViewBuilder content: @escaping () -> Content, onRefresh: @escaping () -> Void) {
        self.content = content
        self.onRefresh = onRefresh
    }

    var body: some View {
        NavigationView {
            List {
                content()
            }
            .listStyle(SidebarListStyle())
            .refreshable {
                onRefresh()
            }
        }
        .frame(maxHeight: .infinity, alignment: .leading)
    }
}


// Vorschau?

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {

        ContentView()

    }

}
