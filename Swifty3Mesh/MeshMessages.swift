import Foundation

public enum MeshMessages {
    case Light(color: MeshLEDColor)
    case Buzzer(frequency: UInt16, duration: UInt16)
    case Broadcast(message: String)
    case Handshake()

    internal var messageType: Data {
        switch self {
        case .Light(let color):
            let (r, g, b) = color.colorType
            return Data(bytes: [messageCode, r, g, b])
        case .Buzzer(let frequency, let duration):
            let (frequencyHiVal, frequencyLowVal) = frequency.split()
            let (durationHiVal, durationLowValue) = duration.split()
            return Data(bytes: [messageCode, frequencyHiVal, frequencyLowVal, durationHiVal, durationLowValue])
        case .Broadcast(let message):
            var messageTypeData = Data(bytes: [messageCode])
            //var messageData = Data(base64Encoded: message)
            //messageTypeData.append(messageData!)
            return messageTypeData
        case .Handshake():
            return Data(bytes: [messageCode, UInt8.max, UInt8.max, UInt8.max, UInt8.max, 0, 5])
        }
    }

    private var messageCode: UInt8 {
        switch self {
        case .Light:
            return 8
        case .Buzzer:
            return 9
        case .Broadcast:
            return 1
        case .Handshake:
            return 2
        }
    }
}
