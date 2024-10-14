//
//  MusicView.swift
//  NeueBluetooth
//
//

import SwiftUI

// Musik Seite

struct MusicView: View {

    @EnvironmentObject var bluetoothManager: BluetoothManager

    @EnvironmentObject var audioRecorderViewModel: AudioRecorderViewModel

    @AppStorage("selectedBackground") var selectedBackground = "background1"

    @EnvironmentObject var languageManager: LanguageManager



    var body: some View {

        NavigationView {

            ZStack {

                Image(selectedBackground)

                    .resizable()

                    .scaledToFill()

                    .edgesIgnoringSafeArea(.all)

                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    .zIndex(-1)



                VStack {

                    Spacer()



                    /*Text("Frequency: \(audioRecorderViewModel.currentFrequency, specifier: "%.2f") Hz")

                        .foregroundColor(.white)

                        .padding()



                    Text("Amplitude: \(audioRecorderViewModel.currentAmplitude, specifier: "%.2f")")

                        .foregroundColor(.white)

                        .padding()*/



                    HStack(spacing: 10) {

                        ForEach(1...15, id: \.self) { index in

                            BarView(amplitude: CGFloat(audioRecorderViewModel.currentAmplitude), index: index)

                        }

                    }

                    .padding(.vertical, 40)



                    Spacer()



                    Button(action: {

                        audioRecorderViewModel.toggleRecording()

                        if audioRecorderViewModel.isRecording {

                            bluetoothManager.startTimer()

                        } else {

                            // Stoppe den Timer, wenn die Aufnahme gestoppt wird

                            bluetoothManager.timer?.invalidate()

                            bluetoothManager.timer = nil

                            

                            bluetoothManager.sendFrequencyAndAmplitude(frequency: 0, amplitude: 0)

                        }

                    }) {

                        Image(systemName: audioRecorderViewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")

                            .resizable()

                            .aspectRatio(contentMode: .fit)

                            .frame(width: 100, height: 100)

                            .foregroundColor(audioRecorderViewModel.isRecording ? .red : .blue)

                    }

                    .padding(.bottom, 40)
                    
                    Text(audioRecorderViewModel.isMicOn ? "Turn Off" : "Turn On")

                                            .foregroundColor(.white)

                                            .font(.headline)

                                            .padding(.bottom, 100)

                }
                //.navigationTitle(languageManager.localizedString(forKey: "Music"))

            }

            .environmentObject(audioRecorderViewModel)

            .onReceive(audioRecorderViewModel.$currentFrequency) { newFrequency in

                            // Hier kannst du auf Änderungen reagieren

                            print("Received new frequency: \(newFrequency)")

                            // Beispiel: BluetoothManager aktualisieren

                            bluetoothManager.sendFrequencyAndAmplitude(frequency: newFrequency, amplitude: audioRecorderViewModel.currentAmplitude)

                        }

            .environment(\.locale, .init(identifier: languageManager.selectedLanguage))

        }

    }

}

// Balken

struct BarView: View {

    var amplitude: CGFloat

    var index: Int



    var body: some View {

        let centerIndex = 8

        let distanceToCenter = abs(centerIndex - index)



        // Höhe des mittleren Balkens

        let centerHeight: CGFloat = amplitude * 800



        // Faktor, um die Größe der seitlichen Balken zu reduzieren

        let scaleFactor = max(1 - Double(distanceToCenter) * 0.1 , 0.5)



        // Berechnung der Höhe basierend auf dem Faktor

        let barHeight = centerHeight * CGFloat(scaleFactor)



        return RoundedRectangle(cornerRadius: 5)

            .foregroundColor(.green)

            .frame(width: 20, height: barHeight)

            .animation(.linear)

    }

}


struct MusicView_Previews: PreviewProvider {

    static var previews: some View {

        MusicView()

    }

}