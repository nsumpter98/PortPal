import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject {
    @Published var isBluetoothOn = false
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var peripheralIsConnected: Bool = false
    @Published var connectedPeripheral: CBPeripheral?
    @Published var discoveredServices: [CBService] = []
    @Published var discoveredCharacteristics: [CBCharacteristic] = []
    @Published var writableCharacteristic: CBCharacteristic?
    private var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Start scanning for peripherals
    func scan() {
        discoveredPeripherals = []
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // Connect to a selected peripheral
    func connect(peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnect(peripheral: CBPeripheral){
        centralManager.cancelPeripheralConnection(peripheral)
        // Clear the connected peripheral
        connectedPeripheral = nil
        
        // Optionally clear characteristics and services
        writableCharacteristic = nil
        discoveredServices = []
        discoveredCharacteristics = []
        
        // Optionally, start scanning again
        scan()
    }
    
    func write(value: Data, characteristic: CBCharacteristic) {
        connectedPeripheral?.writeValue(value, for: characteristic, type: .withResponse)
    }
}


extension BluetoothManager: CBCentralManagerDelegate {
    // CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isBluetoothOn = central.state == .poweredOn
        if central.state == .poweredOn {
            scan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if (!discoveredPeripherals.contains(peripheral) && !(peripheral.name?.contains("Unknown Device") ?? true)) {
            discoveredPeripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil) // Discover all services
    }
    
    // In your CBCentralManagerDelegate extension:

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        disconnect(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("disconnected")
        connectedPeripheral = nil
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        DispatchQueue.main.async {
            self.discoveredServices = services
            self.discoveredCharacteristics = [] // Reset on new service discovery
        }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        DispatchQueue.main.async {
            self.discoveredCharacteristics.append(contentsOf: characteristics)
            for characteristic in characteristics {
                if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                    self.writableCharacteristic = characteristic
                }
            }
        }
    }
}
