import Foundation
import CoreBluetooth

public class MeshManager : NSObject {

    var nodes: [String: CBPeripheral]
    var centralManager: CBCentralManager?
    var peripheralManager: CBPeripheralManager?
    var characteristic: CBMutableCharacteristic?

    internal var pastConnections: [UUID]

    override public init() {
        nodes = [:]
        pastConnections = []
    }

    public func start() {
        if centralManager == nil {
             centralManager = CBCentralManager(delegate: self, queue: nil)
        }
        if peripheralManager == nil {
            peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
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

    public func send(message: MeshMessages, toNodeNamed name: String, forCharacteristic characteristic: CBMutableCharacteristic) {
        guard let peripheral = nodes[name] else { return }
        
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

extension MeshManager : CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("peripheral is powered on")
            characteristic = CBMutableCharacteristic(type: CBUUID(string: "12EC1524-CEC6-11E5-B3AE-0002A5D5C51B"),
                                                         properties: [CBCharacteristicProperties.read, CBCharacteristicProperties.write, CBCharacteristicProperties.writeWithoutResponse],
                                                         value: nil,
                                                         permissions: [CBAttributePermissions.readable, CBAttributePermissions.writeable])
            let service = CBMutableService(type: CBUUID(string: "12ec7140-cec6-11e5-b3ae-0002a5d5c51b"), primary: true)
            service.characteristics = [(characteristic)!]

            peripheralManager?.add(service)
            
            //peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [service.uuid], CBAdvertisementDataLocalNameKey: "foo"])
 
        } else {
            print("Peripheral Manager for Bluetooth is not on")
        }
        
    }
    
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if ((error) != nil) {
            print("error starting advertising: \(error.debugDescription)")
        }
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("Service added")
        let uuid = service.characteristics?.first?.uuid
        print("UUID of added service characteristic is \(uuid)")
        if ((error) != nil) {
            print("error adding service")
        }
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("Received write request!")
    }


}

extension MeshManager : CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Central Manager for Bluetooth is not on")
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else { return }

        if name.contains("Mesh-A282") {
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
        
        print("UUID of discovered characteristic is \(peripheral.services?.first?.characteristics?.first?.uuid)")
        
        print("About to send message to \(peripheral.name)")
        send(message: .Handshake(), toNodeNamed: name)
    }
}

