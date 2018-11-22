import Foundation
import Alamofire

final class ExchangeRates {

    private let rateParser: CurrenciesParser = CurrenciesParser()

    func rateObject (urlString: String, completion : @escaping (Float) -> Void) {
        Alamofire.request(urlString).responseJSON {
            response in
            if let data = response.data {
                print(data)
            }
            print(response)

            switch(urlString) {
            case RateViewController.CBR_LINK:
                DispatchQueue.main.async {
                    completion(self.rateParser.rublePerOneDollar(response: response))
                }
            case RateViewController.CRYPTO_LINK:
                DispatchQueue.main.async {
                    completion(self.rateParser.usdPerOneBitcoin(response: response))
                }
            default:
                DispatchQueue.main.async {
                    completion(0.0)
                }
            }
        }
    }
}

final class CurrenciesParser {

    struct KeyStrings {
        static let keyValute = "Valute"
        static let keyValue = "Value"
        static let keyBPI = "bpi"
        static let keyUSD = "USD"
        static let keyRATE = "rate_float"
    }

    func rublePerOneDollar(response: Alamofire.DataResponse<Any>) -> Float {
        if let jsonObjectFromUrl = response.result.value {
            let allObjects:Dictionary = jsonObjectFromUrl as! Dictionary<String, Any>
            let valuteObject:Dictionary = allObjects[KeyStrings.keyValute] as! Dictionary<String, Any>
            let usdObject:Dictionary = valuteObject[KeyStrings.keyUSD] as! Dictionary<String, Any>
            
            if let rubleNumber = usdObject[KeyStrings.keyValue] as? NSNumber {
                return rubleNumber.floatValue
            }
        }
        return 0.0
    }

    func usdPerOneBitcoin(response: Alamofire.DataResponse<Any>) -> Float {
        if let bitcoinJSON = response.result.value {
            let bitcoinObject:Dictionary = bitcoinJSON as! Dictionary<String, Any>
            let bpiObject:Dictionary = bitcoinObject[KeyStrings.keyBPI] as! Dictionary<String, Any>
            let usdObject:Dictionary = bpiObject[KeyStrings.keyUSD] as! Dictionary<String, Any>

            if let usdNumber = usdObject[KeyStrings.keyRATE] as? NSNumber {
                return  usdNumber.floatValue
            }
        }
        return 0.0
    }
}
