//
//  SettingView.swift
//  NeueBluetooth
//
//

import SwiftUI

// Einstellungen Seite

struct SettingsView: View {

    @EnvironmentObject var bluetoothManager: BluetoothManager

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

                    Image("logo")

                        .resizable()

                        .scaledToFit()

                        .frame(width: 150, height: 150)

                        .padding(.top, 40)



                    List {

                        Section(header: Text("Options")) {

                            NavigationLink(destination: LanguageView()) {

                                Text("Language")

                            }

                            NavigationLink(destination: DesignView()) {

                                Text("Design")

                            }

                            NavigationLink(destination: HelpView()) {

                                Text("Help")

                            }

                        }



                        Section(header: Text("About")){

                            NavigationLink(destination: AboutView()) {

                                Text("About")

                            }

                            NavigationLink(destination: ContactView()) {

                                Text("Contact")

                            }

                        }

                    }

                    .listStyle(InsetGroupedListStyle())

                    .foregroundColor(.white)

                    .scrollContentBackground(.hidden)

                    .cornerRadius(20)

                    .padding(.horizontal, 20)

                    .padding(.bottom, 20)

                }

            }

            .environment(\.locale, .init(identifier: languageManager.selectedLanguage))

        }

    }

}

class SettingsViewModel: ObservableObject {

    @Published var selectedLanguage = Locale.preferredLanguages.first ?? "en"

}


// LanguageView mit Übersetzungen

struct LanguageView: View {

    @EnvironmentObject var languageManager: LanguageManager



    var body: some View {

        VStack {

            Text("Language Setting")

                .foregroundColor(.white)

                .padding(.top, 20)



            // Liste der verfügbaren Sprachen

            List(["en", "de", "tr", "es"], id: \.self) { languageKey in

                Button(action: {



                    languageManager.selectedLanguage = languageKey

                }) {

                    HStack {

                        // Nutze LocalizedStringKey für die Übersetzung

                        Text(LocalizedStringKey(languageKey))

                            .foregroundColor(.white)

                        Spacer()

                        if languageManager.selectedLanguage == languageKey {

                            Image(systemName: "checkmark")

                                .foregroundColor(.white)

                        }

                    }

                }

            }

            .listStyle(GroupedListStyle())

            .padding(.horizontal, 20)

        }

        .environment(\.locale, .init(identifier: languageManager.selectedLanguage))

    }

}



                                                   

// Wahl aus verschiedenen Hintergrundbildern (ca. 420 zu 700)

struct DesignView: View {

    @AppStorage("selectedBackground") var selectedBackground = "background1"

    @EnvironmentObject var languageManager: LanguageManager

    

    var body: some View {

        VStack {

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 20) {

                    ForEach(["background1", "background2", "background3"], id: \.self) { background in

                        ZStack(alignment: .bottomTrailing) {

                            Image(background)

                                .resizable()

                                .scaledToFill()

                                .frame(width: 300, height: 450)

                                .cornerRadius(20)

                                .opacity(selectedBackground == background ? 1 : 0.6)

                            

                            if selectedBackground == background {

                                Image(systemName: "checkmark.circle.fill")

                                    .foregroundColor(.white)

                                    .padding(8)

                                    .background(Color.blue)

                                    .clipShape(Circle())

                                    .offset(x: -10, y: -10)

                                    .onTapGesture {

                                        // Toggling selection on tap

                                        selectedBackground = selectedBackground == "background1" ? "background2" : (selectedBackground == "background2" ? "background3" : "background1")

                                    }

                            }

                        }

                        .onTapGesture {

                            // Tapping the image to select

                            selectedBackground = background

                        }

                    }

                }

            }

            .environment(\.locale, .init(identifier: languageManager.selectedLanguage))

        }

        .navigationBarTitle("Design", displayMode: .inline)

    }

}





// Help/Tutorial

struct HelpView: View {

    var body: some View {

        Text("Help and Support")

            .foregroundColor(.white)

    }

}



// Über Uns

struct AboutView: View {

    var body: some View {

        Text("About Us")

            .foregroundColor(.white)

    }

}



// Seite für Kontaktaufnahme

struct ContactView: View {

    @AppStorage("selectedBackground") var selectedBackground = "background1"

    @EnvironmentObject var languageManager: LanguageManager

    @State private var firstName = ""

    @State private var lastName = ""

    @State private var message = ""

    @State private var isConsentChecked = false

    @State private var showAlert = false



    var body: some View {

        ZStack {

            Image(selectedBackground)

                .resizable()

                .scaledToFill()

                .edgesIgnoringSafeArea(.all)

                .frame(maxWidth: .infinity, maxHeight: .infinity)

                .zIndex(-1)

            

            VStack {

                        HStack {

                            Spacer()

                            // Kreisförmige Buttons für Facebook, Instagram, Mail

                            SocialButton(imageName: "facebooklogo", url: "https://www.facebook.com/veren.erdogan")

                            Spacer()

                            SocialButton(imageName: "instagramlogo", url: "https://www.instagram.com/vakkaserdogan/")

                            Spacer()

                            SocialButton(imageName: "emaillogo", url: "mailto:vakkas.erdogan@hotmail.com")

                            Spacer()

                        }

                        .padding()



                        // Formular

                        Form {

                            Section(header: Text("Contact form")) {

                                TextField("First name", text: $firstName)

                                TextField("Last name", text: $lastName)

                                TextField("Message", text: $message)

                            }



                            Section {

                                Toggle("I agree that this data may be stored and processed for the purpose of contacting me. I am aware that I can revoke my consent at any time.", isOn: $isConsentChecked)

                                    .padding()

                                    .font(.footnote) // Hier die Schriftgröße anpassen





                                Button(action: {

                                    // Hier kannst du den Code für das Senden der Nachricht implementieren

                                    if isConsentChecked {

                                        // Hier implementiere den Code für das Senden der Nachricht (z.B., per Mail)

                                        showAlert = true

                                    }

                                }) {

                                    Text("Send")

                                        .foregroundColor(.white)

                                        .padding()

                                        .frame(maxWidth: .infinity)

                                        .background(isConsentChecked ? Color.blue : Color.gray)

                                        .cornerRadius(10)

                                }

                                .disabled(!isConsentChecked)

                            }

                        }

                    }

                    .navigationBarTitle("Contact")

                    .alert(isPresented: $showAlert) {

                        Alert(title: Text("Message sent"), message: Text("Your message was delivered succesfully"), dismissButton: .default(Text("OK")))

                    }

        }

        .environment(\.locale, .init(identifier: languageManager.selectedLanguage))

    }

}



struct ContactView_Previews: PreviewProvider {

    static var previews: some View {

        ContactView()

    }

}



struct SocialButton: View {

    var imageName: String

    var url: String



    var body: some View {

        Button(action: {

            openURL()

        }) {

            Image(imageName)

                .resizable()

                .aspectRatio(contentMode: .fit)

                .frame(width: 100, height: 100)

                .foregroundColor(.white)

        }

        .buttonStyle(PlainButtonStyle())

        .cornerRadius(20)

    }



    func openURL() {

        guard let url = URL(string: url) else { return }

        UIApplication.shared.open(url)

    }

}