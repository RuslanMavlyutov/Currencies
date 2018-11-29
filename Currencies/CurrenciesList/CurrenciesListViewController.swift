import UIKit

class CurrenciesListViewController: UITableViewController {
    private var refresher: UIRefreshControl!
    private var curList = [String : String]()
    private var selectedCur = String()
    var delegate: CurrenciesListViewControllerDelegate?

    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        tableView.register(CurrencyCellTableViewCell.self, forCellReuseIdentifier: "currencyCell")
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
        if let cell = Bundle.main.loadNibNamed("CurrencyCellTableViewCell", owner: self, options: nil)?.first as? CurrencyCellTableViewCell {

            var curCodes = [String](curList.keys)
            var curDescription = [String](curList.values)
            cell.currencyNameLabel?.text = curCodes[indexPath.row]
            cell.currencyDescriptionLabel?.text = curDescription[indexPath.row]

            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var curCodes = [String](curList.keys)
        selectedCur = curCodes[indexPath.row]
        self.delegate?.currenciesListViewControllerResponse(selectedCurrecncy: selectedCur)
        navigationController?.popViewController(animated: true)
    }
}

protocol CurrenciesListViewControllerDelegate {
    func currenciesListViewControllerResponse(selectedCurrecncy: String)
}
