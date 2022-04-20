//
//  ECEncrypter.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 16.04.2022.
//

import Foundation
import secp256k1

/// Eliptic Curve tool to work with account keys
final class EllipticCurveKeyTool {
    private let context: OpaquePointer

    // MARK: - Init
    init() {
        context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
    }
    
    deinit {
        secp256k1_context_destroy(context)
    }

    // MARK: - Public Methods
    /// Recovers public key from the PrivateKey. Use import(signature:) to convert signature from bytes.
    ///
    /// - Parameters:
    ///   - privateKey: private key bytes
    /// - Returns: public key structure
    func createPublicKey(privateKey: Data) -> secp256k1_pubkey {
        let privateKey = privateKey.bytes
        var publickKey = secp256k1_pubkey()
        _ = secp256k1_ec_pubkey_create(context, &publickKey, privateKey)
        return publickKey
    }

    /// Converts public key from library's data structure to bytes
    ///
    /// - Parameters:
    ///   - publicKey: public key structure to convert.
    ///   - compressed: whether public key should be compressed.
    /// - Returns: If compression enabled, public key is 33 bytes size, otherwise it is 65 bytes.
    func export(publicKey: inout secp256k1_pubkey, compressed: Bool) -> Data {
        var output = Data(count: compressed ? 33 : 65)
        var outputLen: Int = output.count
        let compressedFlags = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
        output.withUnsafeMutableBytes { pointer -> Void in
            guard let p = pointer.bindMemory(to: UInt8.self).baseAddress else { return }
            secp256k1_ec_pubkey_serialize(context, p, &outputLen, &publicKey, compressedFlags)
        }
        return output
    }

}
