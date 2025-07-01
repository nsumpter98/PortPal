//
//  StatusView.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 6/25/25.
//
import SwiftUI

struct StatusView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .foregroundStyle(.blue)
                        .font(.system(size: 24))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("State: \(bluetoothManager.isBluetoothOn ? "Bluetooth ON" : "Bluetooth OFF")")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.bottom, 2)
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)
        }
    }
}

#Preview {
    let bluetoothmanager = BluetoothManager()
    StatusView(bluetoothManager: bluetoothmanager)
}
