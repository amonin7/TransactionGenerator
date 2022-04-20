//
//  ValidationStatus.swift
//  BitcoinTransactionGenerator
//
//  Created by Andrey Minin on 20.04.2022.
//

import Foundation

enum FailureStatus {
    case notAllFilled
    case invalidAddress
    case incorrectNumber
    case spendLimitExceeded
}

enum ValidationStatus {
    case success
    case failure(_ value: FailureStatus)
}
