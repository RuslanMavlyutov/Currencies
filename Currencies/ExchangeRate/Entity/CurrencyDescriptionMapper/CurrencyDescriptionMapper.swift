import Foundation

final class CurrencyDescriptionMapper {
    static func fillPersistenceCurrencyDescription(currencyDescription: PersistenceCurrencyDescription,
                                                   list: CoinProperties) {
        currencyDescription.id = list.id
        currencyDescription.numCode = list.numCode
        currencyDescription.charCode = list.charCode
        currencyDescription.nominal = Int16(list.nominal!)
        currencyDescription.name = list.name
        currencyDescription.value = list.value!
        currencyDescription.previous = list.previous!
    }
}
