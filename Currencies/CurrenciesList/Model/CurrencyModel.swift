import Foundation

final class CurrencyModel {

    static let CBR_LINK = "https://www.cbr-xml-daily.ru/daily_json.js"
    static let CRYPTO_LINK = "https://api.coindesk.com/v1/bpi/currentprice.json"

    private let exchangeRates = ExchangeRates()

    func usdToRouble (_ currency: DailyCurrency) -> Float {
        var valueUSD = Float()
        for coin in currency.coinProperty {
            if coin.charCode == ExchangeRates.KeyStrings.keyUSD {
                valueUSD = coin.value ?? Float()
                break
            }
        }
        return valueUSD
    }

    func usdPerOneBitcoin(_ currency: CryptoCurrency) ->Float {
        var valueUSD = Float()
        for coin in currency.bpi {
            if coin.key == ExchangeRates.KeyStrings.keyUSD {
                valueUSD = coin.value.rateFloat ?? Float()
                break
            }
        }
        return valueUSD
    }

    func cryptoCurrencyList (completion: @escaping (_ result: CryptoCurrency) -> Void) {
        exchangeRates.cryptoCurrency(urlString: CurrencyModel.CRYPTO_LINK) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }

    func currencyList (completion: @escaping (_ result: DailyCurrency) -> Void) {
        exchangeRates.currency(urlString: CurrencyModel.CBR_LINK) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
}
