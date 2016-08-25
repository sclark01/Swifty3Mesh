import Foundation

public enum MeshLEDColor {
    case Red
    case Green
    case Blue
    case Yellow
    case Teal
    case Purple
    case White
    case None

    public static let availableColors = [Red, Green, Blue, Yellow, Teal, Purple, White, None]

    internal var colorType: (UInt8, UInt8, UInt8) {
        switch self {
        case .Red:
            return (1, 0, 0)
        case .Green:
            return (0, 1, 0)
        case .Blue:
            return (0, 0, 1)
        case .Yellow:
            return (1, 1, 0)
        case .Teal:
            return (0, 1, 1)
        case .Purple:
            return (1, 0, 1)
        case .White:
            return (1, 1, 1)
        case .None:
            return (0, 0, 0)
        }
    }
}

