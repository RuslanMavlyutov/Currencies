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
    private var dailyCurrency: DailyCurrency?

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
        //        updateTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(requestRate),
        //                                     userInfo: nil, repeats: true)
        storage.loadPreviousCurrencies { [weak self] result in
            self?.dailyCurrency = result
            if (self?.dailyCurrency?.valute.isEmpty)! {
                self?.currency(completion: { dailyCurrency in
                    guard let valueUSD = self?.currencyModel.usdToRouble(dailyCurrency) else {
                        return
                    }
                    self?.setTextUI(valueUSD)
                })
            } else {
                guard let valueUSD = self?.currencyModel.usdToRouble((self?.dailyCurrency)!) else {
                    return
                }
                self?.setTextUI(valueUSD)
            }
        }
    }

    func currency(completion: @escaping (_ result: DailyCurrency) -> Void) {
        currencyModel.currencyList { [weak self] currency in
            self?.dailyCurrency = currency
            DispatchQueue.main.async {
                completion(currency)
            }
        }
    }

    func setTextUI(_ value: Float) {
        if !value.isZero {
            priceUsdLabel.text = "$1 = \(value) руб."
            firstCurrencyButton.setTitle(KeyStringsProperties.keyEUR, for: .normal)
            lastCurrencyButton.setTitle(KeyStringsProperties.keyRUB, for: .normal)
        }
    }

    @objc func requestRate () {
        setTextUSDToRouble()
        setTextUSDPerOneBTC()
    }

    func setTextUSDToRouble() {
        if (dailyCurrency?.valute.isEmpty)! {
            return
        }
        setTextUI(currencyModel.usdToRouble(dailyCurrency!))
    }

    func setTextUSDPerOneBTC() {
        currencyModel.cryptoCurrencyList {  [weak self] cryptoCurrency in
            if !cryptoCurrency.bpi.isEmpty {
                guard let value = self?.currencyModel.usdPerOneBitcoin(cryptoCurrency) else {
                    return
                }
                self?.priceBTCLabel.text = "1 BTC = $\(value)"
                self?.timeLabel.text = self?.formatter.string(from: Date())
            }
        }
    }

    func currenciesList () {
        if !(dailyCurrency?.valute.isEmpty)! {
            showCurrencies(dailyCurrency!)
        } else {
            updateAndShowCurrencies()
        }
    }

    func showCurrencies(_ dailyList: DailyCurrency) {
        if let vc = viewController() {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            vc.showCurrencies(dailyList)
        }
    }

    func updateAndShowCurrencies() {
        currencyModel.currencyList() { [weak self]
            (dailyCurrency: DailyCurrency) in
            print(dailyCurrency)
            self?.storage.saveDailyCurrencies(dailyCurrency)
            DispatchQueue.main.async {
                if let vc = self?.viewController() {
                    vc.delegate = self
                    self?.navigationController?.pushViewController(vc, animated: true)
                    vc.showCurrencies(dailyCurrency)
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
                                      listCurrency list: DailyCurrency) {
        dailyCurrency = list
        if isFirstCurrencySelected {
            firstCurrencyButton.setTitle(currency, for: .normal)
            if !(firstCurrencyTextField.text?.isEmpty)! {
                let firstCurrency = dailyCurrency?.valute[currency]?.value
                let secondCurrency = dailyCurrency?.valute[(lastCurrencyButton.titleLabel?.text)!]?.value
                let textFieldModel = TextFieldModel(
                    character: String()
                    , firstCurrencyValue: firstCurrency!
                    , secondCurrencyValue: secondCurrency!
                    , firstTextFieldText: firstCurrencyTextField.text!
                    , secondTextFieldText: currency
                    , isFirstTextFieldFilled: true)
                let str = convertModel.changeCurrecncy(textFieldModel)
                changeTextFieldText(string: str, for: lastCurrencyTextField)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension RateViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard NSCharacterSet(charactersIn: KeyStringsProperties.characters).isSuperset(of: NSCharacterSet(charactersIn: string) as CharacterSet),
            !((dailyCurrency?.valute.isEmpty)!) else {
            return false
        }

        if textField == firstCurrencyTextField {
            if string == KeyStringsProperties.keyDot, (firstCurrencyTextField.text?.contains(KeyStringsProperties.keyDot))! {
                return false
            }
            print((lastCurrencyButton.titleLabel?.text)!)
            let firstCurrency = dailyCurrency?.valute[(firstCurrencyButton.titleLabel?.text)!]?.value
            let secondCurrency = dailyCurrency?.valute[(lastCurrencyButton.titleLabel?.text)!]?.value
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
            let firstCurrency = dailyCurrency?.valute[(firstCurrencyButton.titleLabel?.text)!]?.value
            let secondCurrency = dailyCurrency?.valute[(lastCurrencyButton.titleLabel?.text)!]?.value
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

