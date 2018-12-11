import UIKit

class CurrenciesListViewController: UITableViewController {
    private var refresher: UIRefreshControl!
    private var dailyCurrency = DailyCurrency()
    private var selectedCur = String()
    var delegate: CurrenciesListViewControllerDelegate?

    @IBOutlet private var table: UITableView!

    private let storage = CoreDataPersistenceStorage()

    struct KeyFunc {
        static let keyValute = "pull to refresh"
    }

    override func viewDidLoad() {
        tableView.register(cellNibForClass: CurrencyCellTableViewCell.self)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(CurrenciesListViewController.updateDailyCurrency), for: .valueChanged)

        super.viewDidLoad()
    }

    @objc func updateDailyCurrency() {
        let currencyModel = CurrencyModel()
        currencyModel.currencyList() { [weak self]
            (result: DailyCurrency) in
            self?.dailyCurrency = result
            self?.storage.saveDailyCurrencies(result)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    func showCurrencies(_ dailyList: DailyCurrency) {
        dailyCurrency = dailyList
        self.tableView.reloadData()
    }

    func selectedCurrency() -> String {
        return selectedCur
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyCurrency.valute.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(at: indexPath)
        var curCodes = [String](dailyCurrency.valute.keys)

        let coins = [CoinProperty](dailyCurrency.valute.values)
        var curDescription: [String] = []
        for coin in coins {
            curDescription.append(coin.name!)
        }

        cell.configureForCurrencyList(
            charCodeCurrency: curCodes[indexPath.row],
            descriptionCurrency: curDescription[indexPath.row]
        )

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var curCodes = [String](dailyCurrency.valute.keys)
        selectedCur = curCodes[indexPath.row]
        self.delegate?.currenciesListViewController(self, didSelectCurrecncy: selectedCur, listCurrency: dailyCurrency)
    }
}

protocol CurrenciesListViewControllerDelegate {
    func currenciesListViewController(_ ctrl: CurrenciesListViewController,
                                      didSelectCurrecncy currency: String,
                                      listCurrency list: DailyCurrency)
}

extension UITableView {
    func register(cellNibForClass cls: AnyClass) {
        let id = String(describing: cls)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellReuseIdentifier: id)
    }

    func dequeueCell <T: CurrencyCellTableViewCell>(at indexPath: IndexPath) -> T {
        return dequeueReusableCell(
            withIdentifier: String(describing: T.self),
            for: indexPath
            ) as! T
    }
}
