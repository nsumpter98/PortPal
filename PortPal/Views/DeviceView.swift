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