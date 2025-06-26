//
//  DeviceView.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/25/25.
//
import SwiftUI

struct DeviceView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var isPresentingFindDeviceSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let peripheral = bluetoothManager.connectedPeripheral {
                    Text("Connected: \(peripheral.name ?? "Unknown")")
                    ABControlView(bluetoothManager: bluetoothManager, peripheral: peripheral)
                }
            }
            .padding()
            .navigationTitle("Device")
            .toolbar {
                Button(action: {
                    isPresentingFindDeviceSheet = true
                }) {
                    Text("Find")
                    Image(systemName: "filemenu.and.selection")
                }
            }
        }
        .sheet(isPresented: $isPresentingFindDeviceSheet) {
            FindDeviceSheetView(bluetoothManager: bluetoothManager)
            .presentationDetents([
                .height(400),
                .fraction(0.5),
                .medium,
                .large
            ])
        }
    }
}

#Preview {
    var bluetoothmanager = BluetoothManager()
    DeviceView(bluetoothManager: bluetoothmanager)
}
