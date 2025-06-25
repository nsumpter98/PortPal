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
        Text(bluetoothManager.isBluetoothOn ? "Bluetooth ON" : "Bluetooth OFF")
            .tabItem {
                Image(systemName: "paperplane.fill")
                Text("Status")
            }
            .foregroundColor(bluetoothManager.isBluetoothOn ? .green : .red)
            .padding()
    }
}
