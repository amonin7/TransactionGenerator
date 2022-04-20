//
//  PublicKey.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// Public key, that is generated from the private key
public struct PublicKey {
    public let data: Data
    
    /// generates the public key data from the provided private key
    /// - Parameter privateKey: private key hex data
    public init(privateKey: Data) {
        self.data = PubKeyBuilder.generatePublicKey(data: privateKey, compressed: true)
    }
}
