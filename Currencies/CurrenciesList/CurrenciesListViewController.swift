import UIKit

class CurrenciesListViewController: UITableViewController {
    private var refresher: UIRefreshControl!
    private var curList = [String : String]()

    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
//        refresher = UIRefreshControl()
//        refresher.attributedTitle = NSAttributedString(string: "pull to refresh")
//        refresher.addTarget(self, action: #selector(CurrenciesListViewController.refresh), for: UIControlEvents.valueChanged)

//        self.tableView.addSubview(refresher)
//        refresh()
        tableView.register(CurrencyCellTableViewCell.self, forCellReuseIdentifier: "currencyCell")
        super.viewDidLoad()
    }

    func showCurrencies(list: [String : String]) {
        curList = list
        self.tableView.reloadData()
    }

    func refresh() {
        print(curList)
        self.tableView.reloadData()
        self.refresher.endRefreshing()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(curList.count)
        return curList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyCellTableViewCell {
        if let cell = Bundle.main.loadNibNamed("CurrencyCellTableViewCell", owner: self, options: nil)?.first as? CurrencyCellTableViewCell {

            var curCodes = [String](curList.keys)
            var curDescription = [String](curList.values)
//            curCodes.sort()
            cell.currencyNameLabel?.text = curCodes[indexPath.row]
            cell.currencyDescriptionLabel?.text = curDescription[indexPath.row]

            return cell
        }
        return UITableViewCell()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
