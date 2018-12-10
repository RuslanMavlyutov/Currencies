import Foundation

final class ValuteMapper {
    static func fillPersistenceValute(valute: PersistenceValute, name: String) {
        valute.coinName = name
    }
}
