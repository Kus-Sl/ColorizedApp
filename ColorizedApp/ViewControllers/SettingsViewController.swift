//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Вячеслав Кусакин on 11.04.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    //сделать проверку на черный цвет в мейн экране

    @IBOutlet weak var colorView: UIView! {
        didSet { colorView.layer.cornerRadius = 20 }
    }
    @IBOutlet weak var doneButton: UIButton! {
        didSet { doneButton.layer.cornerRadius = 20 }
    }

    @IBOutlet var colorValuesLabels: [UILabel]!
    @IBOutlet var rgbSliders: [UISlider]!
    @IBOutlet var colorValuesTextField: [UITextField]!

    var receivedColor: UIColor!
    var delegate: SettingsViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        for textField in colorValuesTextField {
            textField.delegate = self
        }

        setColorValues(accordingTo: getRGBColorValues(from: receivedColor))
        setViewColor()
    }

    @IBAction func doneButtonPressed() {
        if let passingColor = colorView.backgroundColor {
            delegate.setBackgroundColor(by: passingColor)
        }
        dismiss(animated: true)
    }

    @IBAction func rgbSlidersMove(_ sender: UISlider) {
        setViewColor()
        setSlidersValues(for: sender.tag, from: sender)
    }

    // Стремился избавиться от отдельных аутлетов, поэтому захардкодил через индексы.
    // Думаю, что при работе с RGB, это не мега критично.
    private func setViewColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(rgbSliders[0].value),
            green: CGFloat(rgbSliders[1].value),
            blue: CGFloat(rgbSliders[2].value),
            alpha: 1
        )
    }
}

// MARK: Sliders settings
extension SettingsViewController {

    private func setColorValues(accordingTo colors: [CGFloat]) {
        for (color, slider) in zip(colors, rgbSliders) {
            slider.value = Float(color)
        }

        for (label, slider) in zip(colorValuesLabels, rgbSliders) {
            label.text = getColorValue(from: slider)
        }

        for (textField, slider) in zip(colorValuesTextField, rgbSliders) {
            textField.text = getColorValue(from: slider)
        }
    }

    private func setSlidersValues(for tag: Int, from slider: UISlider ) {
        colorValuesLabels[tag].text = getColorValue(from: slider)
        colorValuesTextField[tag].text = getColorValue(from: slider)
    }

    private func setTextFieldValue(for tag: Int, from textField: UITextField) {
        colorValuesLabels[tag].text = textField.text
        if let text = textField.text {
            if let text = Float(text) {
                rgbSliders[tag].value = text
            }
        }
    }

    private func getRGBColorValues(from color: UIColor) -> [CGFloat] {
        let redComponent = CIColor(color: color).red
        let greenComponent = CIColor(color: color).green
        let blueComponent = CIColor(color: color).blue

        return [redComponent, greenComponent, blueComponent]
    }

    private func getColorValue(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}

// MARK: KeyBoard's methods
extension SettingsViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard isValidValue(value: textField) else { return }
        setTextFieldValue(for: textField.tag, from: textField)
        setViewColor()
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        replaceСommaToDot(for: string, in: textField)
        return true
    }

    private func replaceСommaToDot(for string: String, in tf: UITextField) {
        if string == "," {
            guard let text = tf.text else { return }
            tf.text = text + "."
        }
    }
}

// MARK: Value validation
extension SettingsViewController {

    private func isValidValue(value: UITextField) -> Bool {
        guard let validatingString = value.text else { return false }
        if let validatingNumber = Double(validatingString) {
            if validatingNumber.description.count <= 4 {
                if validatingNumber >= 0 && validatingNumber <= 1.0 {
                } else {
                    showAlert(title: "Ошибка",
                              message: "Введите значение от 0.00 до 1.00",
                              for: value)
                    return false
                }
            }
        }
        return true
    }

    private func showAlert(
        title: String,
        message: String,
        for textField: UITextField
    ) {

        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField.text = nil
        }

        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

