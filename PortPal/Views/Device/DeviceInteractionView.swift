//
//  DeviceDetailView.swift
//  PortPal
//
//  Created by Nathanael Sumpter on 7/1/25.
//
import SwiftUI
import CoreBluetooth

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isSent: Bool // true if user, false if device
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.accentColor.opacity(configuration.isPressed ? 0.85 : 1))
            )
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

struct Bubble: View {
    let message: Message
    var body: some View {
        HStack {
            if message.isSent { Spacer() }
            Text(message.text)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(message.isSent ? Color.accentColor : Color(.systemGray5))
                .foregroundStyle(message.isSent ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            if !message.isSent { Spacer() }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
    }
}

struct DeviceInteractionView: View {
    var peripheral: CBPeripheral
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var message: String = ""
    @State private var messages: [Message] = []
    @FocusState private var inputIsFocused: Bool

    func sendValue(value: String) {
        guard !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        // Add sent message
        let sent = Message(text: value, isSent: true)
        withAnimation {
            messages.append(sent)
            if messages.count > 10 { messages.removeFirst() }
        }
        // Write to peripheral
        if let characteristic = bluetoothManager.writableCharacteristic {
            let data = value.data(using: .utf8)!
            bluetoothManager.write(value: data, characteristic: characteristic)
        }
        // Optionally simulate device echo/response here
        // Uncomment below for demo (remove for real device):
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            let received = Message(text: "OK: \(value)", isSent: false)
            withAnimation {
                messages.append(received)
                if messages.count > 10 { messages.removeFirst() }
            }
        }
        */
    }

    // Call this when device receives a message to display it in the bubbles
    func receiveValue(_ value: String) {
        withAnimation {
            let received = Message(text: value, isSent: false)
            messages.append(received)
            if messages.count > 10 { messages.removeFirst() }
        }
    }

    var body: some View {
        ZStack {
            // Dismiss keyboard on tap outside
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    inputIsFocused = false
                }
            VStack(spacing: 0) {
                // Device name and quick buttons
                VStack(spacing: 16) {
                    Text(peripheral.name ?? "Unknown Device")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .padding(.top)
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Button("G28 - Home all axis") {
                                sendValue(value: "G28")
                            }
                            .buttonStyle(GrowingButton())
                            Button("G0 X210 Y210") {
                                sendValue(value: "G0 X210 Y210 F30000")
                            }
                            .buttonStyle(GrowingButton())
                        }
                        HStack(spacing: 12) {
                            Button("G0 X0 Y0") {
                                sendValue(value: "G0 X0 Y0 F30000")
                            }
                            .buttonStyle(GrowingButton())
                            Button("G0 X110 Y110") {
                                sendValue(value: "G0 X110 Y110 F30000")
                            }
                            .buttonStyle(GrowingButton())
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color(.systemGroupedBackground))
                .padding(.bottom, 2)
                
                Divider().padding(.vertical, 2)
                
                // Message bubbles history, scrolls to bottom
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(messages) { msg in
                                Bubble(message: msg)
                                    .id(msg.id)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .background(Color(.systemGroupedBackground))
                    .onChange(of: messages) { old, _ in
                        if let last = messages.last {
                            scrollProxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.bottom, 4)

                // Manual input at the very bottom
                HStack {
                    TextField("Type G-code...", text: $message)
                        .textFieldStyle(.roundedBorder)
                        .textCase(.uppercase)
                        .disableAutocorrection(true)
                        .autocapitalization(.allCharacters)
                        .focused($inputIsFocused)
                        .onChange(of: message) { oldValue, newValue in
                            let uppercased = newValue.uppercased()
                            if uppercased != newValue {
                                message = uppercased
                            }
                        }
                    Button("Send") {
                        sendValue(value: message)
                        message = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
                    .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
    }
}
