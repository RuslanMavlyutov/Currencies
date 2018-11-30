import UIKit

class CurrenciesListViewController: UITableViewController {
    private var refresher: UIRefreshControl!
    private var curList = [String : String]()
    private var selectedCur = String()
    var delegate: CurrenciesListViewControllerDelegate?

    @IBOutlet private var table: UITableView!
    override func viewDidLoad() {
        tableView.register(cellNibForClass: CurrencyCellTableViewCell.self)
        super.viewDidLoad()
    }

    func showCurrencies(list: [String : String]) {
        curList = list
        self.tableView.reloadData()
    }

    func selectedCurrency() -> String {
        return selectedCur
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(curList.count)
        return curList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(at: indexPath)
        var curCodes = [String](curList.keys)
        var curDescription = [String](curList.values)

        cell.configureForCurrencyList(
            charCodeCurrency: curCodes[indexPath.row],
            descriptionCurrency: curDescription[indexPath.row]
        )

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var curCodes = [String](curList.keys)
        selectedCur = curCodes[indexPath.row]
        self.delegate?.currenciesListViewController(self, didSelectCurrecncy: selectedCur)
    }
}

protocol CurrenciesListViewControllerDelegate {
    func currenciesListViewController(_ ctrl: CurrenciesListViewController, didSelectCurrecncy currency: String)
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
