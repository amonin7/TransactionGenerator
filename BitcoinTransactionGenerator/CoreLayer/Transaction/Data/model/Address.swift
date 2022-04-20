//
//  Address.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 17.04.2022.
//

import Foundation
@testable import Bech32

/// Decoded bitcoin testnet address
public struct Address {
    public let data: Data
    
    /// Generates the raw bitcoin address from the bitcoin **testnet** address
    public init(_ btcAddr: String) throws {
        let (_, raw) = try SegwitAddrCoder().decode(hrp: "tb", addr: btcAddr)
        self.data = raw
    }
}
