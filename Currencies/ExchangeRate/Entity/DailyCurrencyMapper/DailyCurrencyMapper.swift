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
        print(currency.count)
        for currency in currency {
            print(currency)
            dailyCurrencies.date = currency.date!
            dailyCurrencies.previousDate = currency.previousDate!
            dailyCurrencies.previousURL = currency.previousURL!
            dailyCurrencies.timestamp = currency.timeStamp!
            
            for coin in currency.valute! {
                let valuteCoin = coin as! PersistenceValute
                
                let curDescript = CoinProperty()
                curDescript.id = (valuteCoin.descriptionValute?.id)!
                curDescript.numCode = (valuteCoin.descriptionValute?.numCode)!
                curDescript.charCode = (valuteCoin.descriptionValute?.charCode)!
                curDescript.nominal = Int((valuteCoin.descriptionValute?.nominal)!)
                curDescript.name = (valuteCoin.descriptionValute?.name)!
                curDescript.value = (valuteCoin.descriptionValute?.value)!
                curDescript.previous = (valuteCoin.descriptionValute?.previous)!
                
                dailyCurrencies.valute[valuteCoin.coinName!] = curDescript
            }
        }
        return dailyCurrencies
    }
}
