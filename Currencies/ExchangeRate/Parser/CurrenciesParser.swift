import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

final class DailyCurrency: NSObject, Mappable {
    var date: String?
    var previousDate: String?
    var previousURL: String?
    var timestamp: String?
    var valute: [String : CoinProperty] = [:]
    var coinProperty: [CoinProperty] = []

    override init() {
        super.init()
    }

    convenience required init?(map: Map){
        self.init()
    }

    func mapping(map: Map) {
        date <- map["Date"]
        previousDate <- map["PreviousDate"]
        previousURL <- map["PreviousURL"]
        timestamp <- map["Timestamp"]
        valute <- map["Valute"]
    }
}

final class CoinProperty: NSObject, Mappable {
    var id: String?
    var numCode: String?
    var charCode: String?
    var nominal: Int?
    var name: String?
    var value: Float?
    var previous: Float?

    override init() {
        super.init()
    }

    convenience required init?(map: Map){
        self.init()
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

final class CryptoCurrency: NSObject, Mappable {
    var time: [String : String] = [:]
    var disclaimer: String?
    var chartName: String?
    var bpi: [String : fiatProperty] = [:]

    override init() {
        super.init()
    }

    convenience required init?(map: Map){
        self.init()
    }

    func mapping(map: Map) {
        time <- map["time"]
        disclaimer <- map["disclaimer"]
        chartName <- map["chartName"]
        bpi <- map["bpi"]
    }
}

final class fiatProperty: NSObject, Mappable {
    var code: String?
    var symbol: String?
    var rate: String?
    var fiatDescription: String?
    var rateFloat: Float?

    override init() {
        super.init()
    }

    convenience required init?(map: Map){
        self.init()
    }

    func mapping(map: Map) {
        code <- map["code"]
        symbol <- map["symbol"]
        rate <- map["rate"]
        fiatDescription <- map["description"]
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

final class ExchangeRates {
    struct KeyStrings {
        static let keyValute = "Valute"
        static let keyValue = "Value"
        static let keyBPI = "bpi"
        static let keyUSD = "USD"
        static let keyRUB = "RUB"
        static let keyRATE = "rate_float"
    }

    func cryptoCurrency(urlString: String, completion : @escaping (CryptoCurrency) -> Void) {
        Alamofire.request(urlString).responseObject { (response: DataResponse<CryptoCurrency>) in
            guard let cryptoCurrency = response.result.value else {
                return
            }
            completion(cryptoCurrency)
        }
    }

    func currency(urlString: String, completion : @escaping (DailyCurrency) -> Void) {
        Alamofire.request(urlString).responseObject { (response: DataResponse<DailyCurrency>) in
            guard let dailyCurrency = response.result.value else {
                return
            }
            dailyCurrency.valute[KeyStringsProperties.keyRUB] = self.fillRUBValute()
            dailyCurrency.coinProperty = [CoinProperty](dailyCurrency.valute.values)
            completion(dailyCurrency)
        }
    }

    func fillRUBValute() -> CoinProperty {
        let coinProperty = CoinProperty()
        coinProperty.id = String()
        coinProperty.numCode = String()
        coinProperty.charCode = KeyStringsProperties.keyRUB
        coinProperty.nominal = Int()
        coinProperty.name = KeyStringsProperties.descriptRUB
        coinProperty.value = 1
        coinProperty.previous = 1

        return coinProperty
    }
}
