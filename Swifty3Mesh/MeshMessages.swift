import Foundation

public enum MeshMessages {
    case Light(color: MeshLEDColor)
    case Buzzer(volume: Int)

    internal var messageType: Data {
        switch self {
        case .Light(let color):
            let (r, g, b) = color.colorType
            return Data(bytes: [8, r, g, b])
        case .Buzzer:
            return Data(bytes: [9])
        }
    }
}
