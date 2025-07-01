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
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    if let peripheral = bluetoothManager.connectedPeripheral {
                        VStack(spacing: 20) {
                            // Device Info Card
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "dot.radiowaves.left.and.right")
                                        .foregroundStyle(.blue)
                                        .font(.system(size: 24))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(peripheral.name ?? "Unknown Device")
                                            .font(.headline)
                                        Text("State: \(peripheral.state == .connected ? "Connected" : "Not Connected")")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.bottom, 2)
                                Button(role: .destructive) {
                                    bluetoothManager.disconnect(peripheral: peripheral)
                                } label: {
                                    Label("Disconnect", systemImage: "bolt.slash")
                                        .font(.body)
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color(.secondarySystemBackground)))
                            .padding(.horizontal)

                            // Services/Characteristics
                            List {
                                if !bluetoothManager.discoveredServices.isEmpty {
                                    Section("Services") {
                                        ForEach(bluetoothManager.discoveredServices, id: \.uuid) { service in
                                            Text(service.uuid.uuidString)
                                                .font(.footnote)
                                                .foregroundStyle(.primary)
                                        }
                                    }
                                }
                                if !bluetoothManager.discoveredCharacteristics.isEmpty {
                                    Section("Characteristics") {
                                        ForEach(bluetoothManager.discoveredCharacteristics, id: \.uuid) { characteristic in
                                            Text(characteristic.uuid.uuidString)
                                                .font(.footnote)
                                                .foregroundStyle(.primary)
                                        }
                                    }
                                }
                            }
                            .listStyle(.insetGrouped)
                            .frame(maxHeight: 260)
                            .background(Color.clear)

                            // Navigation to Detail
                            NavigationLink(destination:
                                DeviceInteractionView(peripheral: peripheral, bluetoothManager: bluetoothManager)
                            ) {
                                Label("Device Detail", systemImage: "arrow.right")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding([.horizontal, .bottom])
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .background(Color(.systemGroupedBackground))
                    } else {
                        Spacer()
                        VStack(spacing: 20) {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 56, height: 56)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 4)
                            Text("No Device Connected")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            Text("Swipe up or tap the add button to connect a device.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }
                .navigationTitle("Device")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isPresentingFindDeviceSheet = true
                        } label: {
                            Label("Add Device", systemImage: "link.badge.plus")
                        }
                    }
                }
            }
            // Swipe up to present FindDeviceSheetView if not connected
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.height < -40 && !isPresentingFindDeviceSheet && bluetoothManager.connectedPeripheral == nil {
                            isPresentingFindDeviceSheet = true
                        }
                    }
            )
        }
        .navigationViewStyle(.stack)
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
