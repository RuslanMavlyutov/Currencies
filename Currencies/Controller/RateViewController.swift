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
    @IBOutlet weak var timeLabel: UILabel!

    @IBAction func updateLabel(_ sender: UIButton) {
        requestRate()
    }

    static let CBR_LINK = "https://www.cbr-xml-daily.ru/daily_json.js"
    static let CRYPTO_LINK = "https://api.coindesk.com/v1/bpi/currentprice.json"
    static let format = "yyyy-MM-dd HH:mm:ss"
    static let text = "..."

    private let exchangeRates = ExchangeRates()
    private var updateTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        priceUsdLabel.text = RateViewController.text
        priceBTCLabel.text = RateViewController.text
        timeLabel.text = ""

        exchangeRates.rateObject(urlString: RateViewController.CBR_LINK) {
            response in
            print(response)
            self.priceUsdLabel.text = "$1 = \(response) руб."
        }

        updateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(requestRate),
                                     userInfo: nil, repeats: true)
    }

    @objc func requestRate () {
        exchangeRates.rateObject(urlString: RateViewController.CBR_LINK) {
            response in
            print(response)
            self.priceUsdLabel.text = "$1 = \(response) руб."
        }
        exchangeRates.rateObject(urlString: RateViewController.CRYPTO_LINK) {
            response in
            print(response)
            self.priceBTCLabel.text = "1 BTC = $\(response)"

            let formatter = DateFormatter()
            formatter.dateFormat = RateViewController.format
            self.timeLabel.text = formatter.string(from: Date())
        }
    }
}

