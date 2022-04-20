//
//  TxBuilder.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation
import secp256k1

public final class TxBuilder {
    
    /// Builds plain unsigned transaction from pairs of outputs and inputs
    /// - Parameters:
    ///   - receivers: pairs of output address and amount, needed to be sent to this address
    ///   - utxos: amounts of coins, planned to be spent
    /// - Returns: just plain UnsignedTransaction
    static func build(receivers: [(address: Address, amount: UInt64)], utxos: [UnspentTrans]) throws -> UnsignedTransaction {
        let outputs = receivers.map { CurTransactionOutput(value: $1, lockingScript: buildLockingScript(address: $0.data)) }
        let unsignedInputs = utxos.map { TransInput(previousOutput: $0.prevOutput, signatureScript: $0.curOutput.lockingScript, sequence: UInt32.max) }
        let tx = FullTrans(version: 1, marker: 0, flag: 1, inputs: unsignedInputs, outputs: outputs, lockTime: 0)
        return UnsignedTransaction(trans: tx, utxs: utxos)
    }
    
    /// Public function to sign the hash of previously built transaction
    /// - Parameters:
    ///   - unsignedTransaction: raw unsigned transaction
    ///   - key: private key, with which the trans will be signed
    /// - Returns: transaction with assigned signature
    static func sign(_ unsignedTransaction: UnsignedTransaction, with key: PrivateKey) throws -> FullTrans {
        // Define Transaction
        var signingInputs: [TransInput]
        var signingTransaction: FullTrans {
            let tx: FullTrans = unsignedTransaction.trans
            return FullTrans(version: tx.version, inputs: signingInputs, outputs: tx.outputs, lockTime: tx.lockTime)
        }
        
        // Sign
        signingInputs = unsignedTransaction.trans.inputs
        let sigType = SignatureHashType.ALL
        for (i, utxo) in unsignedTransaction.utxs.enumerated() {
            // Sign transaction hash
            let sigHash: Data = signingTransaction.signatureHash(for: utxo.curOutput, inputIndex: i, hashType: sigType)
            let signature: Data = try sign(sigHash, privateKey: key.raw)
            // Update TransactionInput
            signingInputs[i] = TransInput(
                previousOutput: signingInputs[i].previousOutput,
                signatureScript: buildUnlockingScript(signature: signature, sigType: sigType, pubKeyData: key.publicKey.data),
                sequence: signingInputs[i].sequence
            )
        }
        return signingTransaction
        
    }

    // MARK: - Private Methods
    /// Signs raw data with hex private key
    /// - Parameters:
    ///   - data: raw data to be signed
    ///   - privateKey: hex formatted private key to sign data
    /// - Returns: signed data
    private static func sign(_ data: Data, privateKey: Data) throws -> Data {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(ctx) }
        
        let signature = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { signature.deallocate() }

        data.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
            guard let dataPointer = ptr.bindMemory(to: UInt8.self).baseAddress else { return }
            privateKey.withUnsafeBytes { (pkPtr: UnsafeRawBufferPointer) in
                guard let privateKeyPointer = pkPtr.bindMemory(to: UInt8.self).baseAddress else { return }
                secp256k1_ecdsa_sign(ctx, signature, dataPointer, privateKeyPointer, nil, nil)
            }
        }
        
        let normalizedsig = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { normalizedsig.deallocate() }
        secp256k1_ecdsa_signature_normalize(ctx, normalizedsig, signature)
        
        var length: size_t = 128
        var der = Data(count: length)
        der.withUnsafeMutableBytes({ (ptr: UnsafeMutableRawBufferPointer) -> Void in
            guard let pointer = ptr.bindMemory(to: UInt8.self).baseAddress else { return }
            secp256k1_ecdsa_signature_serialize_der(ctx, pointer, &length, normalizedsig)
        })
        der.count = length
        
        return der
    }
    
    /// creates most common locking script:
    /// 0 <20-byte-key-hash> (0x0014{20-byte-key-hash})
    private static func buildLockingScript(address: Data) -> Data {
        var script: Data = Data() + UInt8(0)
        script += UInt8(address.count)
        script += address
        return script
    }
    
    /// build unlocking script particularly for witness program
    private static func buildUnlockingScript(signature: Data, sigType: SignatureHashType, pubKeyData: Data) -> Data {
        let sigWithHashType: Data = signature + UInt8(sigType)
        let sigLen = Data(hex: "0x02") + UInt8(sigWithHashType.count)
        let keyLen = Data() + UInt8(pubKeyData.count)
        return sigLen + sigWithHashType + keyLen + pubKeyData
    }
}
