import Foundation

final class DailyCurrencyMapper {
    static func fillPersistenceCurrency(currency: PersistenceCurrency, list: DailyCurrency) {
        currency.date = list.date
        currency.previousDate = list.previousDate
        currency.previousURL = list.previousURL
        currency.timeStamp = list.timestamp
    }
    
    static func currecnyParser(currency: [PersistenceCurrency]) -> DailyCurrency {
        let dailyCurrencies = DailyCurrency()
        for currency in currency {
            dailyCurrencies.date = currency.date ?? String()
            dailyCurrencies.previousDate = currency.previousDate ?? String()
            dailyCurrencies.previousURL = currency.previousURL ?? String()
            dailyCurrencies.timestamp = currency.timeStamp ?? String()

            guard let valute = currency.valute else { return dailyCurrencies }
            for coin in valute {
                let valuteCoin = coin as! PersistenceCurrencyDescription

                let curDescript = CoinProperty()
                curDescript.id = valuteCoin.id
                curDescript.numCode = valuteCoin.numCode
                curDescript.charCode = valuteCoin.charCode
                curDescript.nominal = Int(valuteCoin.nominal)
                curDescript.name = valuteCoin.name
                curDescript.value = valuteCoin.value
                curDescript.previous = valuteCoin.previous

                dailyCurrencies.coinProperty.append(curDescript)
            }
        }
        return dailyCurrencies
    }
}
