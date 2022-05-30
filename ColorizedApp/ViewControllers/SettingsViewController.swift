//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Вячеслав Кусакин on 11.04.2022.
//

import UIKit

class SettingsViewController: UIViewController {

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
            slider.setValue(Float(color), animated: true)
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

    @objc private func didTapDone() {
        view.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard getValidResult(for: isValid(value: textField)) else {
            textField.text = nil
            return }
        setTextFieldValue(for: textField.tag, from: textField)
        setViewColor()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyBoardToolBar = UIToolbar()
        keyBoardToolBar.sizeToFit()
        textField.inputAccessoryView = keyBoardToolBar

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDone)
        )

        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        keyBoardToolBar.items = [flexBarButton, doneButton]
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        replaceСommaToDot(for: string, in: textField)
    }

    private func replaceСommaToDot(for string: String, in tf: UITextField) -> Bool {
        if string == "," {
            guard let text = tf.text else { return true }
            tf.text = text + "."
            return false
        }
        return true
    }
}

// MARK: Value validation
extension SettingsViewController {

    private func getValidResult(for value: Bool) -> Bool {
        guard value else {
            showAlert(title: "Ошибка",
                      message: "Введите значение от 0.00 до 1.00"
            )
            return false
        }
        return true
    }

    private func isValid(value: UITextField) -> Bool {
        guard let validatingString = value.text else { return false }
        guard let validatingNumber = Double(validatingString) else
        { return false }
        guard validatingNumber.description.count <= 4 else { return false }
        guard validatingNumber >= 0 && validatingNumber <= 1.0 else
        { return false }
        return true
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let alertAction = UIAlertAction(title: "OK", style: .default)

        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
