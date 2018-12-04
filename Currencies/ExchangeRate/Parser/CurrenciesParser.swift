import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

final class DailyCurrencies: Mappable {
    var date: String?
    var previousDate: String?
    var previousURL: String?
    var timestamp: String?
    var valute: [String : CoinProperties] = [:]

    required init?(map: Map){
    }

    func mapping(map: Map) {
        date <- map["Date"]
        previousDate <- map["PreviousDate"]
        previousURL <- map["PreviousURL"]
        timestamp <- map["Timestamp"]
        valute <- map["Valute"]
    }
}

final class CoinProperties: Mappable {
    var id: String?
    var numCode: String?
    var charCode: String?
    var nominal: Int?
    var name: String?
    var value: Float?
    var previous: Float?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        id <- map["ID"]
        numCode <- map["NumCode"]
        charCode <- map["CharCode"]
        nominal <- map["Nominal"]
        name <- map["Name"]
        value <- map["Value"]
        previous <- map["Previous"]
    }
}

final class CryptoCurrencies: Mappable {
    var time: [String : String] = [:]
    var disclaimer: String?
    var chartName: String?
    var bpi: [String : fiatProperties] = [:]

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        time <- map["time"]
        disclaimer <- map["disclaimer"]
        chartName <- map["chartName"]
        bpi <- map["bpi"]
    }
}

final class fiatProperties: Mappable {
    var code: String?
    var symbol: String?
    var rate: String?
    var description: String?
    var rateFloat: Float?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        code <- map["code"]
        symbol <- map["symbol"]
        rate <- map["rate"]
        description <- map["description"]
        rateFloat <- map["rate_float"]
    }
}

//final class TimeUpdated: Mappable {
//    var Updated: Date?
//    var UpdatedISO: Date?
//    var Updateduk: Date?
//
//    required init?(map: Map){
//
//    }
//
//    func mapping(map: Map) {
//        Updated <- (map["updated"], DateTransform())
//        UpdatedISO <- (map["updatedISO"], DateTransform())
//        Updateduk <- (map["updateduk"], DateTransform())
//    }
//}

struct CurrencyList {
    var coins: [String : CoinDescription]
}

struct CoinDescription {
    var description: String
}

final class ExchangeRates {
    private var curValue : [String : Float] = [:]
    struct KeyStrings {
        static let keyValute = "Valute"
        static let keyValue = "Value"
        static let keyBPI = "bpi"
        static let keyUSD = "USD"
        static let keyRUB = "RUB"
        static let keyRATE = "rate_float"
    }

    func rateObject (urlString: String, completion : @escaping (Float) -> Void) {
        let rubleObject:Float = 0.0
        switch(urlString) {
        case CurrencyModel.CBR_LINK:
            DispatchQueue.main.async {
                completion(rubleObject)
            }
        case CurrencyModel.CRYPTO_LINK:
            DispatchQueue.main.async {
                completion(rubleObject)
            }
        default:
            DispatchQueue.main.async {
                completion(rubleObject)
            }
        }
    }

    func rublePerOneDollar(urlString: String, completion : @escaping (Float) -> Void) {
        var rubleObject: Float = 0.0
        Alamofire.request(urlString).responseObject { (response: DataResponse<DailyCurrencies>) in
            let dailyCurrencies = response.result.value
            if let valutes = dailyCurrencies?.valute {
                for coin in valutes {
                    self.curValue[coin.value.charCode!] = coin.value.value!
                    if coin.value.charCode == KeyStrings.keyUSD {
                        rubleObject = coin.value.value!
                    }
                }
            }
            completion(rubleObject)
        }
    }

    func usdPerOneBitcoin(urlString: String, completion : @escaping (Float) -> Void) {
        var rubleObject: Float = 0.0
        Alamofire.request(urlString).responseObject { (response: DataResponse<CryptoCurrencies>) in
            let dailyCurrencies = response.result.value
            if let valutes = dailyCurrencies?.bpi {
                for coin in valutes {
                    if coin.key == KeyStrings.keyUSD {
                        rubleObject = coin.value.rateFloat!
                        break
                    }
                }
            }
            completion(rubleObject)
        }
    }

    func currencies(urlString: String, completion : @escaping (CurrencyList) -> Void) {
        var currenciesList = CurrencyList(coins: [:])
        var coinDescription = CoinDescription(description: String())
        Alamofire.request(urlString).responseObject { (response: DataResponse<DailyCurrencies>) in
            let dailyCurrencies = response.result.value
            if let valutes = dailyCurrencies?.valute {
                for coin in valutes {
                    coinDescription.description = coin.value.name!
                    currenciesList.coins[coin.value.charCode!] = coinDescription
                }
            }
            coinDescription.description = KeyStringsProperties.descriptRUB
            currenciesList.coins[KeyStringsProperties.keyRUB] = coinDescription
            completion(currenciesList)
        }
    }

    func currencyValue() -> [String : Float] {
        curValue[KeyStrings.keyRUB] = 1
        return curValue
    }
}
