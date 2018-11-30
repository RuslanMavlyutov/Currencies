import UIKit

class CurrencyCellTableViewCell: UITableViewCell {

    @IBOutlet private weak var currencyNameLabel: UILabel!
    @IBOutlet private weak var currencyDescriptionLabel: UILabel!

    func configureForCurrencyList(charCodeCurrency: String,
                                  descriptionCurrency: String) {
        currencyNameLabel.text = charCodeCurrency
        currencyDescriptionLabel.text = descriptionCurrency
    }
}
