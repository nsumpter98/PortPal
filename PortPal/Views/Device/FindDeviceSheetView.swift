//
//  FindDeviceSheetView.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/25/25.
//
import SwiftUI

struct FindDeviceSheetView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if (bluetoothManager.discoveredPeripherals.count >= 1){
                    List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                        Button(action: {
                            dismiss()
                            bluetoothManager.connect(peripheral: peripheral)
                        }) {
                            Text(peripheral.name ?? "Unknown Device")
                        }
                        .foregroundColor(Color.white)
                        .tint(.blue)
                    }
                } else {
                    Text("Nothing to show right now! 👻")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let bluetoothmanager = BluetoothManager()
    FindDeviceSheetView(bluetoothManager: bluetoothmanager)
}


