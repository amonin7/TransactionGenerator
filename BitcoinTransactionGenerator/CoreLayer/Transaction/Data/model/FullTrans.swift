//
//  FullTrans.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// Finally made full transaction, which contain all other parts
public struct FullTrans {
    /// Transaction version
    public let version: UInt32
    /// Witness program marker
    public let marker: UInt8
    /// Witness program flag
    public let flag: UInt8
    /// Amount of Transaction inputs
    public var inputsAmount: UIntData {
        return UIntData(inputs.count)
    }
    /// A list of transaction inputs
    public let inputs: [TransInput]
    /// Amount of Transaction outputs
    public var outputsAmount: UIntData {
        return UIntData(outputs.count)
    }
    /// A list of transaction outputs
    public let outputs: [CurTransactionOutput]
    /// Transaction unlocking time
    public let lockTime: UInt32
    /// Transaction hash is made by applying two times SHA256 to the full trancation data
    public var hash: Data {
        return serialized().doubleSHA256
    }
    
    public init(version: UInt32, marker: UInt8 = UInt8(0), flag: UInt8 = UInt8(1),
                inputs: [TransInput], outputs: [CurTransactionOutput], lockTime: UInt32) {
        self.version = version
        self.marker = marker
        self.flag = flag
        self.inputs = inputs
        self.outputs = outputs
        self.lockTime = lockTime
    }
    
    /// Full transaction view
    public func serialized() -> Data {
        var data = Data() + version
        data += marker
        data += flag
        data += inputsAmount.serialized()
        data += inputs.flatMap { $0.serialized() }
        data += outputsAmount.serialized()
        data += outputs.flatMap { $0.serialized() }
        data += inputs.flatMap { $0.signatureScript }
        data += lockTime
        return data
    }
    
    /// Hash for each output
    /// - Parameters:
    ///   - output: the single output of the transaction
    ///   - inputIndex: the index of this single output
    ///   - hashType: type of the hash for this output
    /// - Returns: hash of the output
    public func signatureHash(for output: CurTransactionOutput, inputIndex: Int, hashType: SignatureHashType) -> Data {
        let txin = inputs[inputIndex]
        var data = Data()
        data += version
        data += getPreviousOutputHash()
        data += getSequenceHash()
        data += txin.previousOutput.serialized()
        data += output.scriptCode()
        data += output.value
        data += txin.sequence
        data += getCurrentOutputsHash()
        data += lockTime
        data += UInt32(hashType)
        return data.doubleSHA256
    }
    
    /// Generates the hash of the previous transaction outputs
    internal func getPreviousOutputHash() -> Data {
        let prevOutputs: Data = inputs.reduce(Data()) { $0 + $1.previousOutput.serialized() }
        return prevOutputs.doubleSHA256
    }
    
    /// Generates the hash of the inputs sequences
    internal func getSequenceHash() -> Data {
        let sequences: Data = inputs.reduce(Data()) { $0 + $1.sequence }
        return sequences.doubleSHA256
    }
    
    /// Generates the hash of the outputs itself
    internal func getCurrentOutputsHash() -> Data {
        let outputs: Data = outputs.reduce(Data()) { $0 + $1.serialized() }
        return outputs.doubleSHA256
    }

}
