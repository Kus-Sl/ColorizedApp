//
//  ViewController.swift
//  ColorizedApp
//
//  Created by Вячеслав Кусакин on 11.04.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var redColorValue: UILabel!
    @IBOutlet weak var greenColorValue: UILabel!
    @IBOutlet weak var blueColorValue: UILabel!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        colorView.layer.cornerRadius = 20

        redSlider.minimumTrackTintColor = UIColor.red
        greenSlider.minimumTrackTintColor = UIColor.green
        blueSlider.minimumTrackTintColor = UIColor.blue

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

    private func setColorValue(for slider: UISlider) {
        switch slider {
        case redSlider:
            redColorValue.text = getColorValue(for: slider)
        case greenSlider:
            greenColorValue.text = getColorValue(for: slider)
        default:
            blueColorValue.text = getColorValue(for: slider)
        }
    }

    private func getColorValue(for slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}
