//
//  UnsignedTransaction.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// Plain Unsigned transaction, built just before the signing
/// Used to easily the sigHash for signature creation
public struct UnsignedTransaction {
    public let trans: FullTrans
    public let utxs: [UnspentTrans]
    
    public init(trans: FullTrans, utxs: [UnspentTrans]) {
        self.trans = trans
        self.utxs = utxs
    }
}
