//
//  ContentView.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/25/25.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab){
            Group {
                StatusView(bluetoothManager: bluetoothManager)
                    .tabItem {
                        Image(systemName: "paperplane.fill")
                        Text("Status")
                    }
                    .tag(0)
                DeviceView(bluetoothManager: bluetoothManager)
                    .tabItem {
                        Image(systemName: "externaldrive.connected.to.line.below.fill")
                        Text("Devices")
                    }
                    .tag(1)
            }
            .toolbarBackground(.regularMaterial, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .onChange(of: selectedTab) {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        }
    }
}





#Preview {
    ContentView()
}
