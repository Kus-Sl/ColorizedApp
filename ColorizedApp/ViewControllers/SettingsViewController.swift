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
        if let test = textField.text {
            if let testt = Float(test) {
                rgbSliders[tag].value = testt
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldValue(for: textField.tag, from: textField)
        setViewColor()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        replaceСommaToDot(for: string, in: textField)
    }


    private func replaceСommaToDot(
        for string: String,
        in textField: UITextField
    ) -> Bool {

        if string == "," {
            guard let text = textField.text else { return true }
            textField.text = text + "."
            return false
        }
        return true
    }

}

