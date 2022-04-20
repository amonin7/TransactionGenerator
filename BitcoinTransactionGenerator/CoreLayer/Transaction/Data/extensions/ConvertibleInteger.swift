//
//  ConvertibleInteger.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// a protocol to make + operations between type Data and type UInt<n>
protocol ConvertibleInteger {
    static func + (l: Data, r: Self) -> Data
    static func +=(l: inout Data, r: Self)
}

/// the implimentation of those operations
extension ConvertibleInteger {
    static func + (l: Data, r: Self) -> Data {
        var value = r
        let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
        return l + data
    }
    
    static func +=(l: inout Data, r: Self) {
        l = l + r
    }
}

extension UInt8: ConvertibleInteger {}
extension UInt16: ConvertibleInteger {}
extension UInt32: ConvertibleInteger {}
extension UInt64: ConvertibleInteger {}
