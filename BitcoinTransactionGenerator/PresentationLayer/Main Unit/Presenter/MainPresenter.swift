//
//  MainPresenter.swift
//  BitcoinTransactionGenerator
//
//  Created by Andrey Minin on 20.04.2022.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func handleButtonTapLogic(receiverAddressText: String?,
                              sendAmountText: String?,
                              feeAmountText: String?)
    
    func getInitialAmount() -> String
}

final class MainPresenter {
    // MARK: - Private Properties
    /// weak reference for the view to avoid circle depencies
    private unowned let view: MainViewControllerProtocol
    private let alertFactory: AlertFactory
    /// model
    private let wallet: Wallet

    // MARK: - Init
    init(view: MainViewControllerProtocol, alertFactory: AlertFactory, generator: Wallet) {
        self.view = view
        self.alertFactory = alertFactory
        self.wallet = generator
    }
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    func getInitialAmount() -> String {
        return String(wallet.getInitialAmount()) + " satoshis"
    }
    
    func handleButtonTapLogic(receiverAddressText: String?,
                              sendAmountText: String?,
                              feeAmountText: String?) {
        view.hideLabel()

        let generatedAmount = wallet.getInitialAmount()
        let (vStatus, destination, amount, fee) = InputsValidator.validateInputs(receiverAddress: receiverAddressText,
                                                                                 sendAmount: sendAmountText,
                                                                                 feeAmount: feeAmountText,
                                                                                 initialAmount: generatedAmount)
        
        guard isSuccess(vStatus) else { return }
        let resultText = wallet.generateRawTransaction(destination: destination, amount: amount, fee: fee)
        view.showLabel(text: resultText)
    }
}

// MARK: - Private Methods
private extension MainPresenter {
    /// Processes the validation status.
    /// In case of failure status shows the corresponding alert and returns false.
    /// In case of success just returns true.
    /// - Parameter status: the status, received after validation procedure
    /// - Returns: true if result is success, false if result is failure
    func isSuccess(_ status: ValidationStatus) -> Bool {
        let title: String
        let description: String
        let isSuccess: Bool
        
        switch status {
        case .success:
            // no actrion needed
            title = ""
            description = ""
            isSuccess = true
        case .failure(.notAllFilled):
            title = "Not all fields are filled"
            description = "Please fill all of them. This is needed to generate transaction."
            isSuccess = false
        case .failure(.invalidAddress):
            title = "Invalid btc address"
            description = "Please provide correct btc testnet address (starting with 'tb1')."
            isSuccess = false
        case .failure(.incorrectNumber):
            title = "Incorrect amount"
            description = "Please enter correct amount of satoshis (positive integer value)."
            isSuccess = false
        case .failure(.spendLimitExceeded):
            title = "You're trying to spend more, than you have"
            description = "Sum of values that you entered is bigger, than the amount on your account. Please enter smaller values."
            isSuccess = false
        }
        
        if !isSuccess {
            alertFactory.showAlert(type: .default(text: title, description: description))
        }
        
        return isSuccess
    }
}
