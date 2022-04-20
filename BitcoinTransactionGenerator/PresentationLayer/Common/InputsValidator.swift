//
//  InputsValidator.swift
//  BitcoinTransactionGenerator
//
//  Created by Andrey Minin on 20.04.2022.
//

import Foundation

struct InputsValidator {

    // MARK: - Public Methods
    static func validateInputs(receiverAddress: String?, sendAmount: String?, feeAmount: String?, initialAmount: UInt64) -> (ValidationStatus, String, UInt64, UInt64) {
        guard let destination = receiverAddress else {
            return failureOutput(.notAllFilled)
        }
        if !destination.starts(with: "tb1") {
            return failureOutput(.invalidAddress)
        }
        
        guard let amountStr = sendAmount else {
            return failureOutput(.notAllFilled)
        }
        guard !amountStr.starts(with: "0"), let amount = UInt64(amountStr) else {
            return failureOutput(.incorrectNumber)
        }
        
        guard let feeStr = feeAmount else {
            return failureOutput(.notAllFilled)
        }
        guard !feeStr.starts(with: "0"), let fee = UInt64(feeStr) else {
            return failureOutput(.incorrectNumber)
        }
        
        guard amount + fee <= initialAmount else {
            return failureOutput(.spendLimitExceeded)
        }
        return (.success, destination, amount, fee)
    }

    // MARK: - Private Methods
    private static func failureOutput(_ status: FailureStatus) -> (ValidationStatus, String, UInt64, UInt64) {
        return (.failure(status), "", 0, 0)
    }
}
