//
//  PrivateKey.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// The private key
public struct PrivateKey {
    public let raw: Data
    
    public init?(pk: String) {
        let utxoPkType = PKType.pkType(for: pk)
        switch utxoPkType {
        case .some(let pkType):
            switch pkType {
            case .hex:
                self.raw = Data(hex: pk)
            case .wifUncompressed:
                let decodedPk = Base58.decode(pk)
                let wifData = decodedPk.dropLast(4).dropFirst()
                self.raw = wifData
            case .wifCompressed:
                let decodedPk = Base58.decode(pk)
                let wifData = decodedPk.dropLast(4).dropFirst().dropLast()
                self.raw = wifData
            }
        case .none:
            return nil
        }
    }
    
    public var publicKey: PublicKey {
        return PublicKey(privateKey: raw)
    }
}


