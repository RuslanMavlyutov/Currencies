import Foundation
import CoreData

protocol PersistenceStorage {
    func saveDailyCurrencies(dailyList: DailyCurrencies)
    func loadPreviousCurrencies(completion: (DailyCurrencies) -> Void)
}

final class CoreDataPersistenceStorage: PersistenceStorage {

    private var context: NSManagedObjectContext!

    lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Currencies")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    init() {
        context = persistantContainer.viewContext
    }

    func saveDailyCurrencies (dailyList: DailyCurrencies) {
        fetchPersistenceCurrencies { request in
            if !request.isEmpty {
                removeCurrencies(coins: request)
            }
            var perCur: PersistenceCurrencies
            perCur = PersistenceCurrencies(context: context)

            DailyCurrenciesMapper.fillPersistenceCurrencies(currencies: perCur, list: dailyList)

            var persistenceValute: PersistenceValute
            for coin in (dailyList.valute) {
                persistenceValute = PersistenceValute(context: context)

                ValuteMapper.fillPersistenceValute(valute: persistenceValute, name: coin.key)

                let persistenceCurrencyDescription = PersistenceCurrencyDescription(context: context)
                CurrencyDescriptionMapper.fillPersistenceCurrencyDescription(currencyDescription: persistenceCurrencyDescription,
                                                             list: coin.value)
                persistenceValute.descriptionValute = persistenceCurrencyDescription
                perCur.addToValute(persistenceValute)
            }
            saveContext()
        }
    }

    func loadPreviousCurrencies(completion: (DailyCurrencies) -> Void) {
        fetchPersistenceCurrencies { coins in
            print(coins)
            let dailyCurrencies = DailyCurrenciesMapper.currecniesParser(currencies: coins)
            completion(dailyCurrencies)
        }
    }

    func fetchPersistenceCurrencies(completion: ([PersistenceCurrencies]) -> Void) {
        let fetchRequest = NSFetchRequest<PersistenceCurrencies>(entityName: Key.persistenceCurrencies)
        let coins = try! context.fetch(fetchRequest)
        completion(coins)
    }

    func removeCurrencies(coins: [PersistenceCurrencies]) {
        for coin in coins {
            context.delete(coin)
            saveContext()
        }
    }

    struct Key {
        static let persistenceCurrencies = "PersistenceCurrencies"
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
