import Foundation

final class CurrencyModel {

    static let CBR_LINK = "https://www.cbr-xml-daily.ru/daily_json.js"
    static let CRYPTO_LINK = "https://api.coindesk.com/v1/bpi/currentprice.json"

    private let exchangeRates = ExchangeRates()

    func usdToRouble (completion: @escaping (_ result: Float) -> Void) {
        exchangeRates.rublePerOneDollar(urlString: CurrencyModel.CBR_LINK) { response in
            print(response)
            completion(response)
        }
    }

    func btcToUsd (completion: @escaping (_ result: Float) -> Void) {
        exchangeRates.usdPerOneBitcoin(urlString: CurrencyModel.CRYPTO_LINK) { response in
            print(response)
            completion(response)
        }
    }

    func currencyList (completion: @escaping (_ result: [String: String]) -> Void) {
        exchangeRates.currencies(urlString: CurrencyModel.CBR_LINK) { response in
            print(response)
            completion(response)
        }
    }

    func currencyValue() -> [String : Float] {
        return exchangeRates.currencyValue()
    }
}
