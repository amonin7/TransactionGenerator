//
//  Wallet.swift
//  BitcoinTransactionGenerator
//
//  Created by Andrey Minin on 19.04.2022.
//

import Foundation

final class Wallet {

    // MARK: - Private Properties
    /// the btc address of wallets owner
    private let myAddress = try! Address("tb1qqg7h3z0pjmu9y55mszlyypqeek376ddlzphp9k")
    /// private key from btc wallet
    private let pk = PrivateKey(pk: "cTSBYMwctYEVjkh9skvKmhW3WZcGPgaRYDf1aB8JT71wpbJ9sQhG")!
    /// the locking script of last transaction
    private let txLockingScript: Data = Data(hex: "0014023d7889e196f852529b80be420419cda3ed35bf")
    /// the hash of last transaction
    private let txHash: Data = Data(Data(hex: "b7c2f43693256ff5a6f3d1128b9e426919d76daa517ada2be5bb6b11511c3daa").reversed())
    private let initialAmount: UInt64 = 97000
    private let output: CurTransactionOutput
    private let utxo: UnspentTrans

    // MARK: - Init
    init() {
        self.output = CurTransactionOutput(value: self.initialAmount, lockingScript: txLockingScript)
        self.utxo = UnspentTrans(output: output, outpoint: PrevTransOutput(hash: txHash, index: 1))
    }

    // MARK: - Public Methods
    /// Generates transaction out of provided parameters
    /// - Parameters:
    ///   - destination: the string with address, where the money will be sent
    ///   - amount: the amount to be sent
    ///   - fee: the fee to be charged for the transaction execution
    /// - Returns: signed and serialized raw transaction
    func generateRawTransaction(destination: String, amount: UInt64, fee: UInt64) -> String {
        let address = try! Address(destination)
        let change: UInt64 = initialAmount - amount - fee
        let destinations: [(Address, UInt64)] = [(address, amount), (myAddress, change)]
        let unsignedTx = try! TxBuilder.build(receivers: destinations, utxos: [utxo])
        let signedTx = try! TxBuilder.sign(unsignedTx, with: pk)

        return signedTx.serialized().toHexString()
    }
    
    func getInitialAmount() -> UInt64 {
        return initialAmount
    }
}
