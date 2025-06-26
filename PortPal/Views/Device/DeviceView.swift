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
            ZStack {
                VStack {
                    if let peripheral = bluetoothManager.connectedPeripheral {
                        List{
                            Section("Device Info"){
                                Text("Connected: \(peripheral.name ?? "Unknown")")
                                Text("State: \(peripheral.state)")
                            }
                            Section("Services") {
                                ForEach(bluetoothManager.discoveredServices, id: \.uuid) { service in
                                    Text(service.uuid.uuidString)
                                }
                            }
                            Section("Characteristics"){
                                ForEach(bluetoothManager.discoveredCharacteristics, id: \.uuid) { characteristic in
                                    Text(characteristic.uuid.uuidString)
                                }
                            }
                            Section("Controls"){
                                ABControlView(bluetoothManager: bluetoothManager, peripheral: peripheral)
                            }
                        }
                    } else {
                        Text("No Device Connected")
                            .foregroundStyle(.secondary)
                    }
                }
                .navigationTitle("Device")
                
                /// Floating Action Button
                ActionButtonView(isPresentingFindDeviceSheet: $isPresentingFindDeviceSheet)
                    .background() {
                        Capsule()
                            .fill(.clear)
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
    let bluetoothmanager = BluetoothManager()
    DeviceView(bluetoothManager: bluetoothmanager)
}
