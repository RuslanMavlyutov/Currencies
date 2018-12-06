import Foundation

final class CurrencyMapper {
    static func fillPersistenceCurrencies(currencies: PersistenceCurrencies,
                                          coinName: String,
                                          coinDescription: String) {
        currencies.coins = coinName
        currencies.coinsDescription = coinDescription
    }

    static func currecniesParser(currencies: [PersistenceCurrencies]) -> CurrencyList {
        var curList = CurrencyList(coins: [:])
        for coin in currencies {
            print(#line, coin.coins!, coin.coinsDescription!)
            curList.coins[coin.coins!] = coin.coinsDescription
        }
        return curList
    }
}
