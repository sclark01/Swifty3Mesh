import Foundation

public enum MeshMessages {
    case Light(color: MeshLEDColor)
    case Buzzer(frequency: UInt16, duration: UInt16)

    internal var messageType: Data {
        switch self {
        case .Light(let color):
            let (r, g, b) = color.colorType
            return Data(bytes: [messageCode, r, g, b])
        case .Buzzer(let frequency, let duration):
            let (frequencyHiVal, frequencyLowVal) = frequency.split()
            let (durationHiVal, durationLowValue) = duration.split()
            
            return Data(bytes: [messageCode, frequencyHiVal, frequencyLowVal, durationHiVal, durationLowValue])
        }
    }

    private var messageCode: UInt8 {
        switch self {
        case .Light:
            return 8
        case .Buzzer:
            return 9
        }
    }
}
