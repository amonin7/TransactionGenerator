//
//  ViewController.swift
//  BitcoinTransactionGenerator
//
//  Created by Andrey Minin on 19.04.2022.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func showLabel(text: String)
    func hideLabel()
}

final class MainViewController: UIViewController {

    // MARK: - @IBOutlet Private Properties
    @IBOutlet private weak var initialAmountLabel: UILabel!
    @IBOutlet private weak var generateButton: UIButton!
    @IBOutlet private weak var copyButton: UIButton!
    @IBOutlet private weak var receiverAddressTF: UITextField!
    @IBOutlet private weak var sendAmountTF: UITextField!
    @IBOutlet private weak var feeAmountTF: UITextField!
    @IBOutlet private weak var fullTransactionLabel: UILabel!

    // MARK: - Public Properties
    var presenter: MainPresenterProtocol!

    // MARK: - Init
    init() {
        super.init(nibName: "MainViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - MainViewControllerProtocol
extension MainViewController: MainViewControllerProtocol {
    func showLabel(text: String) {
        fullTransactionLabel.text = text
        copyButton.isEnabled = true
    }

    func hideLabel() {
        fullTransactionLabel.text = nil
        copyButton.isEnabled = false
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func configureView() {
        initialAmountLabel.text = presenter.getInitialAmount()
        fullTransactionLabel.layer.cornerRadius = 6
        
        sendAmountTF.keyboardType = .numberPad
        feeAmountTF.keyboardType = .numberPad
        
        generateButton.layer.cornerRadius = 8
        copyButton.layer.cornerRadius = 8
        copyButton.isEnabled = false
        
        generateButton.addTarget(self, action: #selector(generateButtonTapped(_:)), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyButtonTapped(_:)), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc func generateButtonTapped(_: UIButton) {
        presenter.handleButtonTapLogic(receiverAddressText: receiverAddressTF.text,
                                       sendAmountText: sendAmountTF.text,
                                       feeAmountText: feeAmountTF.text)
    }
    
    @objc func copyButtonTapped(_: UIButton) {
        UIPasteboard.general.string = fullTransactionLabel.text
    }
}
