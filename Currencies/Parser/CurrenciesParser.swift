import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

final class DailyCurrencies: Mappable {
    var Date: String?
    var PreviousDate: String?
    var PreviousURL: String?
    var Timestamp: String?
    var Valute: [String : CoinProperties] = [:]

    required init?(map: Map){
    }

    func mapping(map: Map) {
        Date <- map["Date"]
        PreviousDate <- map["PreviousDate"]
        PreviousURL <- map["PreviousURL"]
        Timestamp <- map["Timestamp"]
        Valute <- map["Valute"]
    }
}

final class CoinProperties: Mappable {
    var ID: String?
    var NumCode: String?
    var CharCode: String?
    var Nominal: Int?
    var Name: String?
    var Value: Float?
    var Previous: Float?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        ID <- map["ID"]
        NumCode <- map["NumCode"]
        CharCode <- map["CharCode"]
        Nominal <- map["Nominal"]
        Name <- map["Name"]
        Value <- map["Value"]
        Previous <- map["Previous"]
    }
}

final class CryptoCurrencies: Mappable {
    var Time: [String : String] = [:]
    var Disclaimer: String?
    var ChartName: String?
    var BPI: [String : fiatProperties] = [:]

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        Time <- map["time"]
        Disclaimer <- map["disclaimer"]
        ChartName <- map["chartName"]
        BPI <- map["bpi"]
    }
}

final class fiatProperties: Mappable {
    var Code: String?
    var Symbol: String?
    var Rate: String?
    var Description: String?
    var RateFloat: Float?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        Code <- map["code"]
        Symbol <- map["symbol"]
        Rate <- map["rate"]
        Description <- map["description"]
        RateFloat <- map["rate_float"]
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

final class ExchangeRates {
    struct KeyStrings {
        static let keyValute = "Valute"
        static let keyValue = "Value"
        static let keyBPI = "bpi"
        static let keyUSD = "USD"
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
            if let valutes = dailyCurrencies?.Valute {
                for coin in valutes {
                    if coin.value.CharCode == KeyStrings.keyUSD {
                        rubleObject = coin.value.Value!
                        break
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
            if let valutes = dailyCurrencies?.BPI {
                for coin in valutes {
                    if coin.key == KeyStrings.keyUSD {
                        rubleObject = coin.value.RateFloat!
                        break
                    }
                }
            }
            completion(rubleObject)
        }
    }

    func currencies(urlString: String, completion : @escaping ([String : String]) -> Void) {
        var list = [String : String]()
        Alamofire.request(urlString).responseObject { (response: DataResponse<DailyCurrencies>) in
            let dailyCurrencies = response.result.value
            if let valutes = dailyCurrencies?.Valute {
                for coin in valutes {
                    list[coin.value.CharCode!] = coin.value.Name
                }
            }
            completion(list)
        }
    }
}
