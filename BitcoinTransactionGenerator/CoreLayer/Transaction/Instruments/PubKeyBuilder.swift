//
//  PubKeyBuilder.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 16.04.2022.
//

import Foundation
import CryptoSwift

final class PubKeyBuilder {
     static func generatePublicKey(data: Data, compressed: Bool) -> Data {
         let encrypter = EllipticCurveKeyTool()
         var publicKey = encrypter.createPublicKey(privateKey: data)
         return encrypter.export(publicKey: &publicKey, compressed: compressed)
     }
}
