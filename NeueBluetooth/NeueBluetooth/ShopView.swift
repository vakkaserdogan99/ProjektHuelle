//
//  ShopView.swift
//  NeueBluetooth
//

import SwiftUI

struct ShopView: View {

    @EnvironmentObject var bluetoothManager: BluetoothManager

    @AppStorage("selectedBackground") var selectedBackground = "background1"



    var body: some View {

        NavigationView {

            ZStack {

                Image(selectedBackground)

                    .resizable()

                    .scaledToFill()

                    .edgesIgnoringSafeArea(.all)

                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    .zIndex(-1)

            

                // ... (Dein bestehender Shop-View-Code)

            }

        }

    }

}

#Preview {
    ShopView()
}
