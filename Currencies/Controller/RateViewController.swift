//
//  ViewController.swift
//  Currencies
//
//  Created by Ruslan Mavlyutov on 01/11/2018.
//  Copyright © 2018 Ruslan Mavlyutov. All rights reserved.
//

import UIKit
import Alamofire

final class RateViewController: UIViewController {

    @IBOutlet weak var priceUsdLabel: UILabel!
    @IBOutlet weak var priceBTCLabel: UILabel!

    @IBAction func updateLabel(_ sender: UIButton) {
        requestRate()
    }

    static let CBR_LINK = "https://www.cbr-xml-daily.ru/daily_json.js"
    static let CRYPTO_LINK = "https://api.coindesk.com/v1/bpi/currentprice.json"
    static let text = "..."

    private let exchangeRates = ExchangeRates()

    override func viewDidLoad() {
        super.viewDidLoad()
        priceUsdLabel.text = RateViewController.text
        priceBTCLabel.text = RateViewController.text

        exchangeRates.rateObject(urlString: RateViewController.CBR_LINK) {
            response in
            print(response)
            self.priceUsdLabel.text = "$1 = \(response) руб."
        }
    }

    func requestRate () {
        exchangeRates.rateObject(urlString: RateViewController.CBR_LINK) {
            response in
            print(response)
            self.priceUsdLabel.text = "$1 = \(response) руб."
        }
        exchangeRates.rateObject(urlString: RateViewController.CRYPTO_LINK) {
            response in
            print(response)
            self.priceBTCLabel.text = "1 BTC = $\(response)"
        }
    }
}

