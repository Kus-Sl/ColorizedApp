//
//  MainViewController.swift
//  ColorizedApp
//
//  Created by Вячеслав Кусакин on 02.05.2022.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingsVC = segue.destination as? SettingsViewController {
            settingsVC.receivedColor = view.backgroundColor
        }
    }
}
