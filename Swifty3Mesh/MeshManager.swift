import Foundation
import CoreBluetooth

public class MeshManager : NSObject {

    var nodes: [String: CBPeripheral]
    var centralManager: CBCentralManager?

    override public init() {
        nodes = [:]
    }

    public func start() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    public func listConnectedNodes() -> [String] {
        return nodes.keys.map { $0 }
    }

    public func send(message: MeshMessages, toNodeNamed name: String) {
        guard let peripheral = nodes[name],
            let characteristic = peripheral.services?.first?.characteristics?.first else { return }

        let data = Data(bytes: [message.messageType])
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
    }
}

extension MeshManager : CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Device Bluetooth is not on")
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else { return }

        if name.contains("VB-") {
            nodes[name] = peripheral
            centralManager?.connect(peripheral, options: nil)
            print("connecting to \(name)")
        }
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        print("did connect to " + peripheral.name!)
        peripheral.discoverServices(nil)
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "")")
    }
}

extension MeshManager : CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("Error Discovering Services")
            return
        }
        guard let service = peripheral.services?.first else { return }
        peripheral.discoverCharacteristics(nil, for: service)
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print("Error Discovering Characteristics")
            return
        }
        guard let characteristic = service.characteristics?.first else { return }

        let initHandshakeString = "011"
        guard let initHandshakeData = initHandshakeString.data(using: String.Encoding.utf8) else { return }
        peripheral.setNotifyValue(true, for: characteristic)

        peripheral.writeValue(initHandshakeData, for: characteristic, type: .withResponse)
    }
}

