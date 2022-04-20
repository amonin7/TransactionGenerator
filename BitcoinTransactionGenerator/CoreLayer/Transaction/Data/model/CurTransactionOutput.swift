//
//  CurTransactionOutput.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// The single output  of the transaction, which we are trying to build
public struct CurTransactionOutput {
    /// Amount to be sent / spent
    public let value: UInt64
    /// ScriptLength
    public var scriptLength: UIntData {
        return UIntData(lockingScript.count)
    }
    /// ScriptPubKey (Locking script)
    public let lockingScript: Data
    
    /// Full script code
    public func scriptCode() -> Data {
        // IDK for sure, if the length should be here...
        return Data() + scriptLength.serialized() + lockingScript
    }
    
    public init(value: UInt64, lockingScript: Data) {
        self.value = value
        self.lockingScript = lockingScript
    }
    
    public func serialized() -> Data {
        return Data() + value + scriptLength.serialized() + lockingScript
    }
}
