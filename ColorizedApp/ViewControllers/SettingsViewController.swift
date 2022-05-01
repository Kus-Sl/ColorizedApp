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

        changeColorValue()
    }

    @IBAction func changeColorView() {
        changeColor()
        changeColorValue()
    }

    private func changeColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }

    private func changeColorValue() {
        redColorValue.text = String(format: "%.2f", redSlider.value)
        greenColorValue.text = String(format: "%.2f", greenSlider.value)
        blueColorValue.text = String(format: "%.2f",blueSlider.value)
    }

}
