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

    @IBOutlet weak var redColorValue: UILabel!
    @IBOutlet weak var greenColorValue: UILabel!
    @IBOutlet weak var blueColorValue: UILabel!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    @IBOutlet weak var doneButton: UIButton! {
        didSet { doneButton.layer.cornerRadius = 20 }
    }

    var receivedColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()

        colorView.layer.cornerRadius = 20

        setSlidersValue(by: receivedColor)
        setColorView()
    }

    @IBAction func rgbSliderMove(_ sender: UISlider) {
        setColorView()
        setColorValue(for: sender)
    }

    private func setColorView() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
}

// MARK: Sliders settings
extension SettingsViewController {

    private func setSlidersValue(by color: UIColor) {
        let rgbColor = CIColor(color: color)

        redSlider.value = Float(rgbColor.red)
        greenSlider.value = Float(rgbColor.green)
        blueSlider.value = Float(rgbColor.blue)

        redColorValue.text = getColorValue(from: redSlider)
        greenColorValue.text = getColorValue(from: greenSlider)
        blueColorValue.text = getColorValue(from: blueSlider)
    }

    private func setColorValue(for slider: UISlider) {
        switch slider {
        case redSlider:
            redColorValue.text = getColorValue(from: slider)
        case greenSlider:
            greenColorValue.text = getColorValue(from: slider)
        default:
            blueColorValue.text = getColorValue(from: slider)
        }
    }

    private func getColorValue(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}
