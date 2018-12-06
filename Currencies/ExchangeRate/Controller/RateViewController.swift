//
//  ViewController.swift
//  Currencies
//
//  Created by Ruslan Mavlyutov on 01/11/2018.
//  Copyright © 2018 Ruslan Mavlyutov. All rights reserved.
//

import UIKit

final class RateViewController: UIViewController {

    @IBOutlet private weak var priceUsdLabel: UILabel!
    @IBOutlet private weak var priceBTCLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var firstCurrencyTextField: UITextField!
    @IBOutlet private weak var lastCurrencyTextField: UITextField!
    @IBOutlet private weak var firstCurrencyButton: UIButton!
    @IBOutlet private weak var lastCurrencyButton: UIButton!

    @IBAction func chooseFirstCurrency(_ sender: UIButton) {
        isFirstCurrencySelected = true
        currenciesList()
    }
    @IBAction func chooseLastCurrency(_ sender: UIButton) {
        isFirstCurrencySelected = false
        currenciesList()
    }
    @IBAction func updateLabel(_ sender: UIButton) {
        requestRate()
    }

    private let currencyModel = CurrencyModel()
    private let convertModel = ConvertModel()
    private var updateTimer: Timer!
    private var isFirstCurrencySelected = false
    private let storage = CoreDataPersistenceStorage()
    private var curList: CurrencyList?

    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = KeyStringsProperties.format
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        priceUsdLabel.text = KeyStringsProperties.text
        priceBTCLabel.text = KeyStringsProperties.text
        timeLabel.text = String()

        currencyModel.usdToRouble() {
            (result: Float) in
            self.priceUsdLabel.text = "$1 = \(result) руб."
            if self.currencyModel.currencyValue().count > 2 {
                self.firstCurrencyButton.setTitle(KeyStringsProperties.keyEUR, for: .normal)
                self.lastCurrencyButton.setTitle(KeyStringsProperties.keyRUB, for: .normal)
            }
        }
        //        updateTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(requestRate),
        //                                     userInfo: nil, repeats: true)
        storage.loadPreviousCurrencies { result in
            print(result)
            curList = result
        }
    }

    @objc func requestRate () {
        currencyModel.usdToRouble() { [weak self]
            (result: Float) in
            self?.priceUsdLabel.text = "$1 = \(result) руб."
        }
        currencyModel.btcToUsd() { [weak self]
            (result: Float) in
            self?.priceBTCLabel.text = "1 BTC = $\(result)"
            self?.timeLabel.text = self?.formatter.string(from: Date())
        }
    }

    func currenciesList () {
        if !(curList?.coins.isEmpty)! {
            showCurrencies(list: curList!)
        } else {
            updateAndShowCurrencies()
        }
    }

    func showCurrencies(list: CurrencyList) {
        if let vc = viewController() {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            vc.showCurrencies(list: list)
        }
    }

    func updateAndShowCurrencies() {
        currencyModel.currencyList() { [weak self]
            (result: CurrencyList) in
            print(result)
            self?.storage.saveDailyCurrencies(list: result)
            DispatchQueue.main.async {
                if let vc = self?.viewController() {
                    vc.delegate = self
                    self?.navigationController?.pushViewController(vc, animated: true)
                    vc.showCurrencies(list: result)
                }
            }
        }
    }

    func viewController() -> CurrenciesListViewController? {
        return UIStoryboard.init(
            name: "Main", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "table"
        ) as? CurrenciesListViewController
    }

    func changeTextFieldText(string: String, for textField: UITextField) {
        textField.text = string
    }
}

extension RateViewController: CurrenciesListViewControllerDelegate {
    func currenciesListViewController(_ ctrl: CurrenciesListViewController,
                                      didSelectCurrecncy currency: String,
                                      listCurrency list: CurrencyList) {
        curList = list
        if isFirstCurrencySelected {
            firstCurrencyButton.setTitle(currency, for: .normal)
            if !(firstCurrencyTextField.text?.isEmpty)! {
                let curVal = currencyModel.currencyValue()
                let firstCurrency = curVal[currency]
                let secondCurrency = curVal[(lastCurrencyButton.titleLabel?.text)!]
                let textFieldModel = TextFieldModel(
                    character: String()
                    , firstCurrencyValue: firstCurrency!
                    , secondCurrencyValue: secondCurrency!
                    , firstTextFieldText: firstCurrencyTextField.text!
                    , secondTextFieldText: currency
                    , isFirstTextFieldFilled: true)
                let str = convertModel.changeCurrecncy(textFieldModel: textFieldModel)
                changeTextFieldText(string: str, for: lastCurrencyTextField)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension RateViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard NSCharacterSet(charactersIn: KeyStringsProperties.characters).isSuperset(of: NSCharacterSet(charactersIn: string) as CharacterSet) else {
            return false
        }

        if textField == firstCurrencyTextField {
            if string == KeyStringsProperties.keyDot, (firstCurrencyTextField.text?.contains(KeyStringsProperties.keyDot))! {
                return false
            }

            let curVal = currencyModel.currencyValue()
            let firstCurrency = curVal[(firstCurrencyButton.titleLabel?.text)!]
            let secondCurrency = curVal[(lastCurrencyButton.titleLabel?.text)!]
            let str = prepareToConvertModel(string: string,
                                            firstValue: firstCurrency!,
                                            secondValue: secondCurrency!,
                                            isFirstTextField: true)
            changeTextFieldText(string: str, for: lastCurrencyTextField)
            return true
        } else if textField == lastCurrencyTextField {
            if string == KeyStringsProperties.keyDot, (lastCurrencyTextField.text?.contains(KeyStringsProperties.keyDot))! {
                return false
            }
            let curVal = currencyModel.currencyValue()
            let firstCurrency = curVal[(firstCurrencyButton.titleLabel?.text)!]
            let secondCurrency = curVal[(lastCurrencyButton.titleLabel?.text)!]
            let str = prepareToConvertModel(string: string,
                                            firstValue: firstCurrency!,
                                            secondValue: secondCurrency!,
                                            isFirstTextField: false)
            changeTextFieldText(string: str, for: firstCurrencyTextField)
            return true
        } else {
            return false
        }
    }

    func prepareToConvertModel(string str: String,
                               firstValue: Float,
                               secondValue: Float,
                               isFirstTextField: Bool) -> String {
        let textFieldModel = TextFieldModel(
            character: str
            , firstCurrencyValue: firstValue
            , secondCurrencyValue: secondValue
            , firstTextFieldText: firstCurrencyTextField.text!
            , secondTextFieldText: lastCurrencyTextField.text!
            , isFirstTextFieldFilled: isFirstTextField)
        return convertModel.convert(textFieldModel: textFieldModel)
    }
}

