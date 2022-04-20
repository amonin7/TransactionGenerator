//
//  MainAssembly.swift
//  BitcoinTransactionGenerator
//
//  Created by Andrey Minin on 20.04.2022.
//

import Foundation
import UIKit

final class MainAssembly {
    static func build() -> UIViewController {
        let wallet = Wallet()
        let vc = MainViewController()
        let alertFactory = AlertFactory(viewController: vc)
        let presenter = MainPresenter(view: vc, alertFactory: alertFactory, generator: wallet)
        vc.presenter = presenter
        return vc
    }

    private init() {}
}
