import UIKit

class CurrenciesListViewController: UITableViewController {
    private var refresher: UIRefreshControl!
    private var dailyCurrencies = DailyCurrencies()
    private var selectedCur = String()
    var delegate: CurrenciesListViewControllerDelegate?

    @IBOutlet private var table: UITableView!

    struct KeyFunc {
        static let keyValute = "pull to refresh"
    }

    override func viewDidLoad() {
        tableView.register(cellNibForClass: CurrencyCellTableViewCell.self)
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: KeyFunc.keyValute)
        refresher.addTarget(self, action: #selector(CurrenciesListViewController.updateDailyCurrency), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)

        super.viewDidLoad()
    }

    @objc func updateDailyCurrency() {
        let currencyModel = CurrencyModel()
        currencyModel.currencyList() { [weak self]
            (result: DailyCurrencies) in
            self?.dailyCurrencies = result
            let storage = CoreDataPersistenceStorage()
            storage.saveDailyCurrencies(dailyList: result)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refresher.endRefreshing()
            }
        }
    }

    func showCurrencies(list: DailyCurrencies) {
        dailyCurrencies = list
        self.tableView.reloadData()
    }

    func selectedCurrency() -> String {
        return selectedCur
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyCurrencies.valute.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(at: indexPath)
        var curCodes = [String](dailyCurrencies.valute.keys)

        let coins = [CoinProperties](dailyCurrencies.valute.values)
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
        var curCodes = [String](dailyCurrencies.valute.keys)
        selectedCur = curCodes[indexPath.row]
        self.delegate?.currenciesListViewController(self, didSelectCurrecncy: selectedCur, listCurrency: dailyCurrencies)
    }
}

protocol CurrenciesListViewControllerDelegate {
    func currenciesListViewController(_ ctrl: CurrenciesListViewController,
                                      didSelectCurrecncy currency: String,
                                      listCurrency list: DailyCurrencies)
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
