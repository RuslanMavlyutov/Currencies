import Foundation
import CoreData

protocol PersistenceStorage {
    func loadStorage()
    func saveDailyCurrencies(_ dailyList: DailyCurrency)
    func loadPreviousCurrencies(completion: @escaping (DailyCurrency) -> Void)
}

final class CoreDataPersistenceStorage: PersistenceStorage {
    struct Strings {
        static let containerName = "Currencies"
    }

    private var context: NSManagedObjectContext {
        return persistentContainer!.viewContext
    }

    private let queue = DispatchQueue.global(qos: .userInitiated)
    private var persistentContainer: NSPersistentContainer?

    init() {
        loadStorage()
    }

    func loadStorage() {
        persistentContainer = NSPersistentContainer(name: Strings.containerName)
        persistentContainer!.loadPersistentStores { [weak self] (storeDescription, error) in
            self?.showErrorMessage(error)
        }
    }

    func showErrorMessage(_ error: Error?) {
        if let error = error as NSError? {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

    func saveDailyCurrencies (_ dailyList: DailyCurrency) {
        queue.async { [weak self]() -> Void in
            guard let strongSelf = self else {
                return
            }
            if let request = strongSelf.fetchPersistenceCurrencies(),
                !request.isEmpty {
                strongSelf.removeCurrencies(coins: request)
            }
            let perCur = PersistenceCurrency(context: strongSelf.context)
            DailyCurrencyMapper.fillPersistenceCurrency(currency: perCur, list: dailyList)

            var persistenceCurrencyDescription: PersistenceCurrencyDescription
            for coin in dailyList.coinProperty {
                persistenceCurrencyDescription = PersistenceCurrencyDescription(context: strongSelf.context)
                CurrencyDescriptionMapper.fillPersistenceCurrencyDescription(currencyDescription: persistenceCurrencyDescription, list: coin)
                perCur.addToValute(persistenceCurrencyDescription)
            }
            strongSelf.saveContext()
        }
    }

    func loadPreviousCurrencies(completion: @escaping (DailyCurrency) -> Void) {
        queue.async { [weak self]() -> Void in
            guard let strongSelf = self else { return }
            if let coins = strongSelf.fetchPersistenceCurrencies() {
                let dailyCurrencies = DailyCurrencyMapper.currecnyParser(currency: coins)
                DispatchQueue.main.async { () -> Void in
                    completion(dailyCurrencies)
                }
            }
        }
    }

    func fetchPersistenceCurrencies() -> [PersistenceCurrency]? {
        let fetchRequest = NSFetchRequest<PersistenceCurrency>(entityName:
            String(describing: PersistenceCurrency.self))
        if let persistenceContainer = try? context.fetch(fetchRequest) {
            return persistenceContainer
        }
        return nil
    }

    func removeCurrencies(coins: [PersistenceCurrency]) {
        for coin in coins {
            context.delete(coin)
            saveContext()
        }
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                print("Cannot to save to db")
            }
        }
    }
}
