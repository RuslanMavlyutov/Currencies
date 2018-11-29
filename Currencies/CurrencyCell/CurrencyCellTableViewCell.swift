import UIKit

class CurrencyCellTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
