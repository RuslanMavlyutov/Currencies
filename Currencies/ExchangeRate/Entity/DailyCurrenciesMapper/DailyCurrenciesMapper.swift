import Foundation

final class DailyCurrenciesMapper {
    static func fillPersistenceCurrencies(currencies: PersistenceCurrencies, list: DailyCurrencies) {
        currencies.date = list.date
        currencies.previousDate = list.previousDate
        currencies.previousURL = list.previousURL
        currencies.timeStamp = list.timestamp
    }
    
    static func currecniesParser(currencies: [PersistenceCurrencies]) -> DailyCurrencies {
        let dailyCurrencies = DailyCurrencies()
        print(currencies.count)
        for currency in currencies {
            print(currency)
            dailyCurrencies.date = currency.date!
            dailyCurrencies.previousDate = currency.previousDate!
            dailyCurrencies.previousURL = currency.previousURL!
            dailyCurrencies.timestamp = currency.timeStamp!
            
            for coin in currency.valute! {
                let valuteCoin = coin as! PersistenceValute
                
                let curDescript = CoinProperties()
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
