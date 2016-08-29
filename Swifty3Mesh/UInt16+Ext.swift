import Foundation

extension UInt16 {
    func split() -> (UInt8, UInt8) {
        let mask:UInt16 = 0x00ff
        let low = UInt8(self >> 8)
        let hi = UInt8(self & mask)

        return (hi, low)
    }
}

