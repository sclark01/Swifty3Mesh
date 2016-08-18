import Foundation
import CoreBluetooth

public class MeshManager {

    let startingVal: Int

    public init(withStartingValue value: Int) {
        self.startingVal = value
    }

    public func start() -> Int {
        return 1 + startingVal
    }
}


// connect()
//   - pair
//   - get heartbeat, maintain list of nodes in the mesh
// list nodes()
// sendMessage(message, nodeId)
//   - properly format & communicate with the nodes 
