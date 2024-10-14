//
//  HomeView.swift
//  NeueBluetooth
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @AppStorage("selectedBackground") var selectedBackground = "background1"
    @EnvironmentObject var languageManager: LanguageManager
    
    @State private var isMenuVisible = false
    @State private var actMode = 0
    @State private var selectedColor1: Color = .gray
    @State private var selectedColor2: Color = .gray
    @State private var selectedColor3: Color = .gray
    @State private var selectedColor4: Color = .gray
    @State private var selectedColor5: Color = .gray
    @State private var isColorPicker1Presented: Bool = false
    @State private var isColorPicker2Presented: Bool = false
    @State private var isColorPicker3Presented: Bool = false
    @State private var isColorPicker4Presented: Bool = false
    @State private var isColorPicker5Presented: Bool = false
    
    let group1Identifier : UInt8 = 1
    let group2Identifier : UInt8 = 2
    let group3Identifier : UInt8 = 3
    let group4Identifier : UInt8 = 4
    let group5Identifier : UInt8 = 5
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(selectedBackground)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(-1)
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        if isMenuVisible {
                            MenuView(bluetoothManager: bluetoothManager)
                                .frame(width: geometry.size.width / 2)
                            // .background(Color(UIColor.systemBackground))
                                .offset(x: isMenuVisible ? 0 : -geometry.size.width / 2)
                                .animation(.easeInOut)
                                .colorMultiply(Color.white.opacity(0.5))
                        }
                        VStack {
                            if bluetoothManager.isConnected {
                                Text("Connected")
                                    .foregroundColor(.green)
                                    .font(.headline)
                                    .padding()
                            } else {
                                Text("Not Connected")
                                    .foregroundColor(.red)
                                    .font(.headline)
                                    .padding()
                            }
                                VStack (spacing: 0) {
                                    if bluetoothManager.isConnected {
                                        Button(action: {
                                            // Aktion für den linken Balken-Button
                                            actMode = 1
                                            // Hier kannst du die Farbe ändern oder die Farbauswahl öffnen
                                            isColorPicker1Presented.toggle()
                                        }) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(selectedColor1)
                                                .frame(width: geometry.size.width / 4 , height: 10)
                                        }
                                            .sheet(isPresented: $isColorPicker1Presented) {
                                                ColorCirclePicker(selectedColor: $selectedColor1)
                                                    .onChange(of: selectedColor1) { newColor1 in
                                                        let rgbComponents = newColor1.rgbComponents
                                                        bluetoothManager.sendCustom( red1: rgbComponents.red, green1: rgbComponents.green, blue1: rgbComponents.blue, red2: selectedColor2.rgbComponents.red, green2: selectedColor2.rgbComponents.green, blue2: selectedColor2.rgbComponents.blue, red3: selectedColor3.rgbComponents.red, green3: selectedColor3.rgbComponents.green, blue3: selectedColor3.rgbComponents.blue, red4: selectedColor4.rgbComponents.red, green4: selectedColor4.rgbComponents.green, blue4: selectedColor4.rgbComponents.blue, red5: selectedColor5.rgbComponents.red, green5: selectedColor5.rgbComponents.green, blue5: selectedColor5.rgbComponents.blue, brightness: bluetoothManager.brightness)
                                                    }
                                            }
                                    }
                                    HStack (spacing: 0) {
                                        VStack{
                                            if bluetoothManager.isConnected {
                                                Button(action: {
                                                    // Aktion für den linken Balken-Button
                                                    actMode = 1
                                                    // Hier kannst du die Farbe ändern oder die Farbauswahl öffnen
                                                    isColorPicker2Presented.toggle()
                                                }) {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .foregroundColor(selectedColor2)
                                                        .frame(width: 10, height: geometry.size.height / 6)
                                                }
                                                    .sheet(isPresented: $isColorPicker2Presented) {
                                                        ColorCirclePicker(selectedColor: $selectedColor2)
                                                            .onChange(of: selectedColor2) { newColor2 in
                                                                let rgbComponents = newColor2.rgbComponents
                                                                bluetoothManager.sendCustom(red1: selectedColor1.rgbComponents.red, green1: selectedColor1.rgbComponents.green, blue1: selectedColor1.rgbComponents.blue, red2: rgbComponents.red, green2: rgbComponents.green, blue2: rgbComponents.blue, red3: selectedColor3.rgbComponents.red, green3: selectedColor3.rgbComponents.green, blue3: selectedColor3.rgbComponents.blue, red4: selectedColor4.rgbComponents.red, green4: selectedColor4.rgbComponents.green, blue4: selectedColor4.rgbComponents.blue, red5: selectedColor5.rgbComponents.red, green5: selectedColor5.rgbComponents.green, blue5: selectedColor5.rgbComponents.blue, brightness: bluetoothManager.brightness)
                                                            }
                                                    }
                                            }
                                            if bluetoothManager.isConnected {
                                                Button(action: {
                                                    // Aktion für den linken Balken-Button
                                                    actMode = 1
                                                    // Hier kannst du die Farbe ändern oder die Farbauswahl öffnen
                                                    isColorPicker3Presented.toggle()
                                                }) {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .foregroundColor(selectedColor3)
                                                        .frame(width: 10, height: geometry.size.height / 6)
                                                }
                                                    .sheet(isPresented: $isColorPicker3Presented) {
                                                        ColorCirclePicker(selectedColor: $selectedColor3)
                                                            .onChange(of: selectedColor3) { newColor3 in
                                                                let rgbComponents = newColor3.rgbComponents
                                                                bluetoothManager.sendCustom(red1: selectedColor1.rgbComponents.red, green1: selectedColor1.rgbComponents.green, blue1: selectedColor1.rgbComponents.blue, red2: selectedColor2.rgbComponents.red, green2: selectedColor2.rgbComponents.green, blue2: selectedColor2.rgbComponents.blue, red3: rgbComponents.red, green3: rgbComponents.green, blue3: rgbComponents.blue, red4: selectedColor4.rgbComponents.red, green4: selectedColor4.rgbComponents.green, blue4: selectedColor4.rgbComponents.blue, red5: selectedColor5.rgbComponents.red, green5: selectedColor5.rgbComponents.green, blue5: selectedColor5.rgbComponents.blue, brightness: bluetoothManager.brightness)
                                                            }
                                                    }
                                            }
                                        }
                                        
                                        Image("iphone14neu") // Stelle sicher, dass dies der korrekte Name aus deinen Assets ist
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width / 3)
                                            .padding()
                                        // .background(Color(UIColor.systemBackground))
                                            .foregroundColor(Color(UIColor.label))
                                            .background(Color.clear) // Hinzugefügt, um den Hintergrund transparent zu machen
                                        //.colorMultiply(Color.white.opacity(0.7)) // Passe die Transparenz hier an
                                        VStack{
                                            if bluetoothManager.isConnected {
                                            Button(action: {
                                                // Aktion für den linken Balken-Button
                                                actMode = 1
                                                // Hier kannst du die Farbe ändern oder die Farbauswahl öffnen
                                                isColorPicker4Presented.toggle()
                                            }) {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(selectedColor4)
                                                    .frame(width: 10, height: geometry.size.height / 6)
                                                   }
                                                .sheet(isPresented: $isColorPicker4Presented) {
                                                    ColorCirclePicker(selectedColor: $selectedColor4)
                                                        .onChange(of: selectedColor4) { newColor4 in
                                                            let rgbComponents = newColor4.rgbComponents
                                                            bluetoothManager.sendCustom(red1: selectedColor1.rgbComponents.red, green1: selectedColor1.rgbComponents.green, blue1: selectedColor1.rgbComponents.blue, red2: selectedColor2.rgbComponents.red, green2: selectedColor2.rgbComponents.green, blue2: selectedColor2.rgbComponents.blue, red3: selectedColor3.rgbComponents.red, green3: selectedColor3.rgbComponents.green, blue3: selectedColor3.rgbComponents.blue, red4: rgbComponents.red, green4: rgbComponents.green, blue4: rgbComponents.blue, red5: selectedColor5.rgbComponents.red, green5: selectedColor5.rgbComponents.green, blue5: selectedColor5.rgbComponents.blue, brightness: bluetoothManager.brightness)
                                                        }
                                                }
                                            }
                                            if bluetoothManager.isConnected {
                                            Button(action: {
                                                // Aktion für den linken Balken-Button
                                                actMode = 1
                                                // Hier kannst du die Farbe ändern oder die Farbauswahl öffnen
                                                isColorPicker5Presented.toggle()
                                            }) {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(selectedColor5)
                                                    .frame(width: 10, height: geometry.size.height / 6)
                                                    }
                                                .sheet(isPresented: $isColorPicker5Presented) {
                                                    ColorCirclePicker(selectedColor: $selectedColor5)
                                                        .onChange(of: selectedColor5) { newColor5 in
                                                            let rgbComponents = newColor5.rgbComponents
                                                            bluetoothManager.sendCustom(red1: selectedColor1.rgbComponents.red, green1: selectedColor1.rgbComponents.green, blue1: selectedColor1.rgbComponents.blue, red2: selectedColor2.rgbComponents.red, green2: selectedColor2.rgbComponents.green, blue2: selectedColor2.rgbComponents.blue, red3: selectedColor3.rgbComponents.red, green3: selectedColor3.rgbComponents.green, blue3: selectedColor3.rgbComponents.blue, red4: selectedColor4.rgbComponents.red, green4: selectedColor4.rgbComponents.green, blue4: selectedColor4.rgbComponents.blue, red5: rgbComponents.red, green5: rgbComponents.green, blue5: rgbComponents.blue, brightness: bluetoothManager.brightness)
                                                        }
                                                }
                                            }
                                        }
                                    }
                                }
                            if bluetoothManager.isConnected {
                                Toggle("LED Control", isOn: $bluetoothManager.isLedOn)
                                    .disabled(!bluetoothManager.isConnected)
                                    .toggleStyle(SwitchToggleStyle(tint: .green))
                                    .onChange(of: bluetoothManager.isLedOn) { newValue in
                                        let colorComponents = bluetoothManager.selectedColor.rgbComponents
                                        bluetoothManager.sendLedStateBrightnessAndColor(isOn: newValue, brightness: bluetoothManager.brightness, red: colorComponents.red, green: colorComponents.green, blue: colorComponents.blue)
                                    }
                                    .padding()
                                
                                Slider(value: $bluetoothManager.brightness, in: 0...1, step: 0.01)
                                    .disabled(!bluetoothManager.isConnected)
                                    .accentColor(.green)
                                    .onChange(of: bluetoothManager.brightness) { newValue in
                                        let colorComponents = bluetoothManager.selectedColor.rgbComponents
                                        if actMode == 1 {
                                            bluetoothManager.sendCustom(red1: selectedColor1.rgbComponents.red, green1: selectedColor1.rgbComponents.green, blue1: selectedColor1.rgbComponents.blue, red2: selectedColor2.rgbComponents.red, green2: selectedColor2.rgbComponents.green, blue2: selectedColor2.rgbComponents.blue, red3: selectedColor3.rgbComponents.red, green3: selectedColor3.rgbComponents.green, blue3: selectedColor3.rgbComponents.blue, red4: selectedColor4.rgbComponents.red, green4: selectedColor4.rgbComponents.green, blue4: selectedColor4.rgbComponents.blue, red5: selectedColor5.rgbComponents.red, green5: selectedColor5.rgbComponents.green, blue5: selectedColor5.rgbComponents.blue, brightness: newValue)
                                        } else {
                                            bluetoothManager.sendLedStateBrightnessAndColor(isOn: bluetoothManager.isLedOn, brightness: newValue, red: colorComponents.red, green: colorComponents.green, blue: colorComponents.blue)
                                        }
                                    }
                                    .padding()
                                
                                Text("Brightness: \(Int(bluetoothManager.brightness * 100))%")
                                    .font(.subheadline)
                                    .padding()
                                
                                ColorPicker("", selection: $bluetoothManager.selectedColor)
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .disabled(!bluetoothManager.isConnected)
                                    .onChange(of: bluetoothManager.selectedColor) { newColor in
                                        actMode = 0
                                        let rgbComponents = newColor.rgbComponents
                                        bluetoothManager.sendLedStateBrightnessAndColor(isOn: bluetoothManager.isLedOn, brightness: bluetoothManager.brightness, red: rgbComponents.red, green: rgbComponents.green, blue: rgbComponents.blue)
                                    }
                                    .padding()
                            } else {
                                Toggle("LED Control", isOn: $bluetoothManager.isLedOn) .disabled(!bluetoothManager.isConnected)
                                    .toggleStyle(SwitchToggleStyle(tint: .red))
                                
                                Slider(value: $bluetoothManager.brightness, in: 0...1, step: 0.01)
                                    .disabled(!bluetoothManager.isConnected)
                                    .accentColor(.red)
                                
                                ColorPicker(" ", selection: $bluetoothManager.selectedColor)
                                    .disabled(!bluetoothManager.isConnected)
                            }
                        }
                        .navigationBarTitle("LED Case")
                        .navigationBarItems(leading: Button(action: {
                            withAnimation {
                                isMenuVisible.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .foregroundColor(Color(UIColor.label))
                                .font(.title)
                        })
                        .overlay(
                            ZStack {
                                if isMenuVisible {
                                    Color.black.opacity(0.5)
                                        .onTapGesture {
                                            withAnimation {
                                                isMenuVisible.toggle()
                                            }
                                        }
                                }
                            }
                        )
                    }
                }
            }
            .environment(\.locale, .init(identifier: languageManager.selectedLanguage))
        }
    }
}
// Seitliches Menü
struct MenuView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var isRefreshing = false
    
    var body: some View {
        RefreshableNavigationView(content: {
            ForEach(bluetoothManager.devices, id: \.identifier) { device in
                Button(action: {
                    bluetoothManager.selectedDevice = device
                    bluetoothManager.connectToDevice()
                }) {
                    HStack {
                        Text(device.name ?? "Unknown Device")
                        if bluetoothManager.isConnected && bluetoothManager.selectedDevice == device {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
        }, onRefresh: {
            bluetoothManager.refreshDeviceList()
            bluetoothManager.startScanning()
        })
    }
}

// Farbkreis
struct ColorCirclePicker: View {
    @Binding var selectedColor: Color
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    let predefinedColors: [[Color]] = [
        [.white, .black, Color(red: 0.8, green: 0.0, blue: 0.0), Color(red: 0.0, green: 0.8, blue: 0.0)],
        [Color(red: 0.0, green: 0.0, blue: 0.8), .yellow, Color(red: 0.0, green: 1.0, blue: 1.0), Color(red: 0.8, green: 0.0, blue: 0.8)]
    ]
    
    var body: some View {
        VStack {
            Spacer()
            Text("Swipe over the circle to change the colour")
                .padding(.bottom, 24)
            Spacer()
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(selectedColor)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 210, height: 210)
                )
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let vector = CGVector(dx: value.location.x - 75, dy: value.location.y - 75)
                        let angle = atan2(vector.dy, vector.dx)
                        var hue = (angle + .pi) / (2.0 * .pi)
                        if hue < 0 {
                            hue += 1.0
                        }
                        self.selectedColor = Color(hue: Double(hue), saturation: 1.0, brightness: 1.0)
                    }
                )
            
            Spacer()
            
            ForEach(predefinedColors, id: \.self) { rowColors in
                HStack {
                    ForEach(rowColors, id: \.self) { color in
                        Circle()
                            .foregroundColor(color)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                self.selectedColor = color
                            }
                    }
                }
                .padding(.bottom, 10)
            }
            Spacer()
        }
        .padding()
    }
}

// Farberweiterung
extension Color {
    var rgbComponents: (red: Double, green: Double, blue: Double) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (Double(red), Double(green), Double(blue))
    }
}