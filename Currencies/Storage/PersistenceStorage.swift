import Foundation
import CoreData

protocol PersistenceStorage {
    func saveDailyCurrencies(list: CurrencyList)
    func loadPreviousCurrencies(completion: (CurrencyList) -> Void)
}

final class CoreDataPersistenceStorage: PersistenceStorage {

    var context: NSManagedObjectContext!

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

    func saveDailyCurrencies(list: CurrencyList) {
        fetchPersistenceCurrencies { request in
            if !request.isEmpty {
                removeCurrencies(coins: request)
            }
            var perCur: PersistenceCurrencies
            for (coin, description) in list.coins {
                perCur = PersistenceCurrencies(context: context)
                CurrencyMapper.fillPersistenceCurrencies(currencies: perCur,
                                                         coinName: coin,
                                                         coinDescription: description)
                saveContext()
            }
        }
    }

    func loadPreviousCurrencies(completion: (CurrencyList) -> Void) {
        fetchPersistenceCurrencies { coins in
            let curList = CurrencyMapper.currecniesParser(currencies: coins)
            completion(curList)
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
