import UIKit

class CurrenciesListViewController: UITableViewController {
    private var refresher: UIRefreshControl!
    private var dailyCurrency = DailyCurrency()
    private var selectedCur = String()
    var delegate: CurrenciesListViewControllerDelegate?

    @IBOutlet private var table: UITableView!

    private var storage: CoreDataPersistenceStorage?

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
            self?.storage?.saveDailyCurrencies(result)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    func showCurrencies(_ dailyList: DailyCurrency, _ storage: CoreDataPersistenceStorage) {
        dailyCurrency = dailyList
        self.storage = storage
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
        let coin = dailyCurrency.coinProperty[indexPath.row]
        guard let code = coin.charCode, let name = coin.name else {
            return cell
        }
        cell.configureForCurrencyList(charCodeCurrency: code,
                                      descriptionCurrency: name)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let code = dailyCurrency.coinProperty[indexPath.row].charCode {
            selectedCur = code
        }
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
