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