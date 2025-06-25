//
//  ContentView.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/25/25.
//

import SwiftUI
import CoreBluetooth


struct StatusView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        Text(bluetoothManager.isBluetoothOn ? "Bluetooth ON" : "Bluetooth OFF")
            .tabItem {
                Image(systemName: "paperplane.fill")
                Text("Status")
            }
            .foregroundColor(bluetoothManager.isBluetoothOn ? .green : .red)
            .padding()
    }
}


struct DeviceView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        VStack {
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                Button(peripheral.name ?? "Unknown Device") {
                    bluetoothManager.connect(peripheral: peripheral)
                }
            }
            if let peripheral = bluetoothManager.connectedPeripheral {
                Text("Connected: \(peripheral.name ?? "Unknown")")
                HStack {
                    Button("Send A") {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        if let characteristic = bluetoothManager.writableCharacteristic {
                            let data = "A".data(using: .utf8)!
                            bluetoothManager.write(value: data, characteristic: characteristic)
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    
                    Button("Send B") {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        if let characteristic = bluetoothManager.writableCharacteristic {
                            let data = "B".data(using: .utf8)!
                            bluetoothManager.write(value: data, characteristic: characteristic)
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    Button("Disconnect") {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        bluetoothManager.disconnect(peripheral: peripheral)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
        }
        .padding()
    }
}


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
                // Haptic Feedback
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        }
    }
}





#Preview {
    ContentView()
}
