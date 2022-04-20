//
//  UIntData.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// The struct that represents the convertion from Integer to Data
/// This is very usefull particularly, when serializing transaction
public struct UIntData: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = UInt64

    // MARK: - Public Methods
    let rawValue: UInt64
    let data: Data

    // MARK: - Init
    public init(integerLiteral value: UInt64) {
        rawValue = value
        switch value {
        case 0...252:
            data = Data() + UInt8(value).littleEndian
        case 253...0xffff:
            data = Data() + UInt8(0xfd).littleEndian + UInt16(value).littleEndian
        case 0x10000...0xffffffff:
            data = Data() + UInt8(0xfe).littleEndian + UInt32(value).littleEndian
        default:
            data = Data() + UInt8(0xff).littleEndian + UInt64(value).littleEndian
        }
    }
        
    init(_ value: Int) {
        self.init(integerLiteral: UInt64(value))
    }
    
    // MARK: - Public Methods
    func serialized() -> Data {
        return data
    }
}
