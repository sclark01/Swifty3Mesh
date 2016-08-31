import Foundation
import Swifty3Mesh

public struct Alarm {

    private let manager: MeshManager
    private let colors = MeshLEDColor.availableColors

    init(manager: MeshManager) {
        self.manager = manager
    }

    public func run() {
        let colorsAsArray = Array(colors.values)
        manager.listConnectedNodes().forEach { node in
            let color = colorsAsArray[randomInt(min: 0, max: colorsAsArray.count - 1)]
            manager.send(message: .Light(color: color), toNodeNamed: node)
            manager.send(message: .Buzzer(frequency: UInt16(randomInt(min: 10, max: 99)), duration: 500), toNodeNamed: node)
            Thread.sleep(forTimeInterval: 0.5)
        }
    }

    private func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}
