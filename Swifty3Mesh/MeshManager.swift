import Foundation
import CoreBluetooth

public class MeshManager : NSObject, CBCentralManagerDelegate {

    var nodes: Array<String>
    var centralManager: CBCentralManager?

    override public init() {
        nodes = []
    }

    public func start() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        } else {
            // Bluetooth is not on, alert user
        }
    }

     public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name)
    }
}


// connect()
//   - pair
//   - get heartbeat, maintain list of nodes in the mesh
// list nodes()
// sendMessage(message, nodeId)
//   - properly format & communicate with the nodes 
