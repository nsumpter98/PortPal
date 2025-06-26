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
            
            StatusView(bluetoothManager: bluetoothManager)
                .tabItem {
                    Label("Status", systemImage: "paperplane.fill")
                }
                .tag(0)
            DeviceView(bluetoothManager: bluetoothManager)
                .tabItem {
                    Label("Devices", systemImage: "externaldrive.connected.to.line.below.fill")
                }
                .tag(1)
            
        }
        .onChange(of: selectedTab) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
}





#Preview {
    ContentView()
}
