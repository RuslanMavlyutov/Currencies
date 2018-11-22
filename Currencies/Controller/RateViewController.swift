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

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceBTCLabel: UILabel!

    @IBAction func updateLabel(_ sender: UIButton) {
        requestRate()
    }

    static let CBR_LINK = "https://www.cbr-xml-daily.ru/daily_json.js"
    static let CRYPTO_LINK = "https://api.coindesk.com/v1/bpi/currentprice.json"
    static let keyBPI = "bpi"
    static let keyUSD = "USD"
    static let keyRATE = "rate_float"

    private let exchangeRates = ExchangeRates()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        priceLabel.text = "..."

        Alamofire.request(RateViewController.CBR_LINK).responseJSON {
            response in
            if let data = response.data {
                print(data)
            }
            print(response)

            if let rubleJSON = response.result.value {
                let rubleObject:Dictionary = rubleJSON as! Dictionary<String, Any>
                let usdObject:Dictionary = rubleObject["Valute"] as! Dictionary<String, Any>
                let newObject:Dictionary = usdObject["USD"] as! Dictionary<String, Any>
                var usd:Float = 0

                if let usdNumber = newObject["Value"] as? NSNumber {
                    usd = usdNumber.floatValue
                }
                self.priceLabel.text = "$\(usd)"
            }
        }
        print("Loading web service")
    }

    func requestRate () {
        exchangeRates.rateObject(urlString: RateViewController.CBR_LINK) {
            response in
            print(response)
            self.priceLabel.text = "$1 = \(response) руб."
        }
        exchangeRates.rateObject(urlString: RateViewController.CRYPTO_LINK) {
            response in
            print(response)
            self.priceBTCLabel.text = "1 BTC = $\(response)"
        }
    }
}

