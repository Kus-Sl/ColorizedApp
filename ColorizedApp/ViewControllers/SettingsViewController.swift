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

    @IBOutlet weak var redColorValueLabel: UILabel!
    @IBOutlet weak var greenColorValueLabel: UILabel!
    @IBOutlet weak var blueColorValueLabel: UILabel!

    @IBOutlet var colorValuesLabels: [UILabel]!
    @IBOutlet var rgbSliders: [UISlider]!
    @IBOutlet var colorValuesTextField: [UITextField]!

    @IBOutlet weak var doneButton: UIButton! {
        didSet { doneButton.layer.cornerRadius = 20 }
    }

    var receivedColor: UIColor!
    var delegate: SettingsViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        setSlidersValues(accordingTo: getRGBColorValues(from: receivedColor))
        setViewColor()
    }

    @IBAction func doneButtonPresed() {
        if let passingColor = colorView.backgroundColor {
            delegate.setBackgroundColor(by: passingColor)
        }
        dismiss(animated: true)
    }

    @IBAction func rgbSlidersMove(_ sender: UISlider) {
        setViewColor()

        switch sender.tag {
        case 0:
            redColorValueLabel.text = getColorValue(from: sender)
        case 1:
            greenColorValueLabel.text = getColorValue(from: sender)
        default:
            blueColorValueLabel.text = getColorValue(from: sender)
        }
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
    private func setSlidersValues(accordingTo colors: [CGFloat]) {
        for (color, slider) in zip(colors, rgbSliders) {
            slider.value = Float(color)
        }

        for (label, slider) in zip(colorValuesLabels, rgbSliders) {
            label.text = getColorValue(from: slider)
        }
    }

    private func getRGBColorValues(from color: UIColor) -> [CGFloat] {
        let redColor = CIColor(color: color).red
        let greenColor = CIColor(color: color).green
        let blueColor = CIColor(color: color).blue

        let rgbColorValues = [redColor, greenColor, blueColor]
        return rgbColorValues
    }

    private func getColorValue(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}
