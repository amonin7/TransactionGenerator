//
//  PreviousTransOutput.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// The output of the previous transaction, which is used to generate the input of the cur transaction
public struct PrevTransOutput {
    /// Hash of the previous transaction.
    public let hash: Data
    /// Index of this output in previous transaction.
    public let index: UInt32
    
    public init(hash: Data, index: UInt32) {
        self.hash = hash
        self.index = index
    }
    
    public func serialized() -> Data {
        return Data() + hash + index
    }
}
