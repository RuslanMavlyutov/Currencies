import Foundation

final class CurrencyDescriptionMapper {
    static func fillPersistenceCurrencyDescription(currencyDescription: PersistenceCurrencyDescription,
                                                   list: CoinProperty) {
        currencyDescription.id = list.id
        currencyDescription.numCode = list.numCode
        currencyDescription.charCode = list.charCode
        currencyDescription.nominal = Int16(list.nominal ?? Int())
        currencyDescription.name = list.name
        currencyDescription.value = list.value ?? Float()
        currencyDescription.previous = list.previous ?? Float()
    }
}
