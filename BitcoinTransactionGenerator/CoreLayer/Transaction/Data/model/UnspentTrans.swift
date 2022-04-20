//
//  UnspentTrans.swift
//  TxGenComLine
//
//  Created by Andrey Minin on 15.04.2022.
//

import Foundation

/// Unspent transaction outputs
public struct UnspentTrans {
    public let curOutput: CurTransactionOutput
    public let prevOutput: PrevTransOutput
    
    public init(output: CurTransactionOutput, outpoint: PrevTransOutput) {
        self.curOutput = output
        self.prevOutput = outpoint
    }
}
