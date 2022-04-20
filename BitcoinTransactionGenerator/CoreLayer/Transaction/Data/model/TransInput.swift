//
//  TransInput.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// Input of the transaction
public struct TransInput {
    /// Previous transaction output
    public let previousOutput: PrevTransOutput
    /// Length of the sigScript
    public var scriptLength: UIntData {
        return UIntData(signatureScript.count)
    }
    /// Script to confirm transaction authorization
    public let signatureScript: Data
    /// Transaction version as defined by the sender. Almost always equal to 0xffffffff
    public let sequence: UInt32
    
    public init(previousOutput: PrevTransOutput, signatureScript: Data, sequence: UInt32) {
        self.previousOutput = previousOutput
        self.signatureScript = signatureScript
        self.sequence = sequence
    }
        
    public func serialized() -> Data {
        return Data()
            + previousOutput.serialized()
            + Data(hex: "0x00")
            + sequence
    }
}
