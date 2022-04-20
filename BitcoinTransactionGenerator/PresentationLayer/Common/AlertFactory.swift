//
//  AlertShower.swift
//  BitcoinTransactionGenerator
//
//  Created by Andrey Minin on 20.04.2022.
//

import Foundation
import UIKit

enum AlertTypes {
    case `default`(text: String, description: String)
}

final class AlertFactory {

    // MARK: - Private Properties
    private weak var viewController: UIViewController?

    // MARK: - Init
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods
    func showAlert(type: AlertTypes) {
        let alert: UIAlertController

        switch type {
        case let .default(text, description):
            alert = UIAlertController(title: text, message: description,  preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
        }
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
