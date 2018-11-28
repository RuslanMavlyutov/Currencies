//
//  ViewController.swift
//  Currencies
//
//  Created by Ruslan Mavlyutov on 01/11/2018.
//  Copyright © 2018 Ruslan Mavlyutov. All rights reserved.
//

import UIKit

final class RateViewController: UIViewController {

    @IBOutlet weak var priceUsdLabel: UILabel!
    @IBOutlet weak var priceBTCLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBAction func chooseFirstCurrency(_ sender: UIButton) {
        currenciesList(vc: firstCurrencyVc!)
    }
    @IBAction func chooseLastCurrency(_ sender: UIButton) {
        currenciesList(vc: lastCurrencyVc!)
    }
    @IBAction func updateLabel(_ sender: UIButton) {
        requestRate()
    }

    static let format = "yyyy-MM-dd HH:mm:ss"
    static let text = "..."

    private let currencyModel = CurrencyModel()
    private var updateTimer: Timer!

    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = RateViewController.format
        return formatter
    }()

    private let firstCurrencyVc = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        .instantiateViewController(withIdentifier: "table") as? CurrenciesListViewController

    private let lastCurrencyVc = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        .instantiateViewController(withIdentifier: "table") as? CurrenciesListViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        priceUsdLabel.text = RateViewController.text
        priceBTCLabel.text = RateViewController.text
        timeLabel.text = ""

        currencyModel.usdToRouble() {
            (result: Float) in
            self.priceUsdLabel.text = "$1 = \(result) руб."
        }

//        updateTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(requestRate),
//                                     userInfo: nil, repeats: true)
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

    func currenciesList (vc: CurrenciesListViewController) {
        currencyModel.currencyList() { [weak self]
            (result: [String : String]) in
            print(result)
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(vc, animated: true)
                vc.showCurrencies(list: result)
            }
        }
    }
}

