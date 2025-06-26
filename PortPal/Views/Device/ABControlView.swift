//
//  ABControlView.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/25/25.
//
import SwiftUI
import CoreBluetooth

/// simple view to send either A or B to the target device
struct ABControlView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    var peripheral: CBPeripheral
    
    var body: some View {
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
