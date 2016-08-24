import Foundation

public enum MeshMessages {
    case Light(color: UIColor)

    internal var messageType: UInt8 {
        switch self {
        case .Light:
            return 8
        }
    }
}
