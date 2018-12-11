import Foundation
import CoreData

protocol PersistenceStorage {
    func loadStorage(_ container: NSPersistentContainer)
    func saveDailyCurrencies(_ dailyList: DailyCurrency)
    func loadPreviousCurrencies(completion: @escaping (DailyCurrency) -> Void)
}

final class CoreDataPersistenceStorage: PersistenceStorage {
    struct Strings {
        static let containerName = "Currencies"
    }

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private let queue = DispatchQueue.global(qos: .utility)

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Strings.containerName)
        loadStorage(container)
        return container
    }()

    func loadStorage(_ container: NSPersistentContainer) {
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            self?.showErrorMessage(error)
        })
    }

    func showErrorMessage(_ error: Error?) {
        if let error = error as NSError? {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

    func saveDailyCurrencies (_ dailyList: DailyCurrency) {
        let request = fetchPersistenceCurrencies()
        queue.async { [weak self]() -> Void in
            guard let strongSelf = self else {
                return
            }
            if !request.isEmpty {
                strongSelf.removeCurrencies(coins: request)
            }
            let perCur = PersistenceCurrency(context: strongSelf.context)
            DailyCurrencyMapper.fillPersistenceCurrency(currency: perCur, list: dailyList)

            var persistenceValute: PersistenceValute
            for coin in (dailyList.valute) {
                persistenceValute = PersistenceValute(context: strongSelf.context)

                ValuteMapper.fillPersistenceValute(valute: persistenceValute, name: coin.key)

                let persistenceCurrencyDescription = PersistenceCurrencyDescription(context: strongSelf.context)
                CurrencyDescriptionMapper.fillPersistenceCurrencyDescription(currencyDescription: persistenceCurrencyDescription,
                                                                             list: coin.value)
                persistenceValute.descriptionValute = persistenceCurrencyDescription
                perCur.addToValute(persistenceValute)
            }
            strongSelf.saveContext()
        }
    }

    func loadPreviousCurrencies(completion: @escaping (DailyCurrency) -> Void) {
        queue.async { [weak self]() -> Void in
            guard let strongSelf = self else { return }
            let coins = strongSelf.fetchPersistenceCurrencies()
            let dailyCurrencies = DailyCurrencyMapper.currecnyParser(currency: coins)
            DispatchQueue.main.async { () -> Void in
                completion(dailyCurrencies)
            }
        }
    }

    func fetchPersistenceCurrencies() -> [PersistenceCurrency] {
        let fetchRequest = NSFetchRequest<PersistenceCurrency>(entityName: String(describing: PersistenceCurrency.self))
        return try! context.fetch(fetchRequest)
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
