//
//  SignatureHashType.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 16.04.2022.
//

import Foundation


public struct SignatureHashType {
    fileprivate let uint8: UInt8
    init(_ uint8: UInt8) {
        self.uint8 = uint8
    }
    
    public static let ALL = SignatureHashType(0x01)
    public static let NONE = SignatureHashType(0x02)
    public static let SINGLE = SignatureHashType(0x03)
}

extension UInt8 {
    public init(_ hashType: SignatureHashType) {
        self = hashType.uint8
    }
}

extension UInt32 {
    public init(_ hashType: SignatureHashType) {
        self = UInt32(UInt8(hashType))
    }
}
