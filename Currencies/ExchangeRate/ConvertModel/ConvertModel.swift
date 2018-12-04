import Foundation

struct TextFieldModel {
    var character: String
    var firstCurrencyValue: Float
    var secondCurrencyValue: Float
    var firstTextFieldText: String
    var secondTextFieldText: String
    var isFirstTextFieldFilled: Bool
}

struct KeyStringsProperties {
    static let format = "yyyy-MM-dd HH:mm:ss"
    static let text = "..."
    static let keyEUR = "EUR"
    static let keyRUB = "RUB"
    static let descriptRUB = "Российский рубль"
    static let characters = "0123456789."
    static let keyDot = "."
    static let keyDotNull = ".0"
    static let keyNullDot = "0."
}

final class ConvertModel {
    func convert(textFieldModel: TextFieldModel) -> String {
        var numberStr = String()
        var ratio = Float()
        if textFieldModel.isFirstTextFieldFilled {
            numberStr = textFieldModel.firstTextFieldText + textFieldModel.character
            ratio = textFieldModel.firstCurrencyValue / textFieldModel.secondCurrencyValue
        } else {
            numberStr = textFieldModel.secondTextFieldText + textFieldModel.character
            ratio = textFieldModel.secondCurrencyValue / textFieldModel.firstCurrencyValue
        }
        if textFieldModel.character.isEmpty {
            numberStr.removeLast()
        }
        if numberStr == KeyStringsProperties.keyDot {
            numberStr = KeyStringsProperties.keyNullDot
        }
        if !numberStr.isEmpty {
            var textValue = "\(Float(numberStr)! * ratio)"
            if textValue.count > 2, String(textValue.suffix(2)) == KeyStringsProperties.keyDotNull {
                textValue = String(textValue.dropLast(2))
            }
            return textValue
        } else {
            return String()
        }
    }

    func changeCurrecncy(textFieldModel: TextFieldModel) -> String {
        var numberStr = textFieldModel.firstTextFieldText
        let ratio = textFieldModel.firstCurrencyValue / textFieldModel.secondCurrencyValue
        if numberStr == KeyStringsProperties.keyDot {
            numberStr = KeyStringsProperties.keyDotNull
        }
        if !numberStr.isEmpty {
            return "\(Float(numberStr)! * ratio)"
        } else {
            return String()
        }
    }
}
