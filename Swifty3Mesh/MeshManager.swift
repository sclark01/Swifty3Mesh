import Foundation
import CoreBluetooth

public class MeshManager : NSObject {

    var nodes: [String: CBPeripheral]
    var centralManager: CBCentralManager?

    internal var pastConnections: [UUID]

    override public init() {
        nodes = [:]
        pastConnections = []
    }

    public func start() {
        if centralManager == nil {
             centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }

    public func listConnectedNodes() -> [String] {
        return nodes.keys.map { $0 }
    }

    public func send(message: MeshMessages, toNodeNamed name: String) {
        guard let peripheral = nodes[name],
            let characteristic = peripheral.services?.first?.characteristics?.first else { return }

        peripheral.writeValue(message.messageType, for: characteristic, type: .withoutResponse)
    }

    public func sendToAllNodes(message: MeshMessages) {
        for node in listConnectedNodes() {
            send(message: message, toNodeNamed: node)
        }
    }

    public func disconnect(fromNode node: String) {
        guard let peripheral = nodes[node] else { return }
        centralManager?.cancelPeripheralConnection(peripheral)
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
        print("did connect to " + peripheral.name!)

        peripheral.delegate = self
        peripheral.discoverServices(nil)
        pastConnections.append(peripheral.identifier)
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "")")
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnected from \(peripheral.name)")
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

        guard let name = peripheral.name else { return }
        send(message: .Light(color: .White), toNodeNamed: name)
    }
}

