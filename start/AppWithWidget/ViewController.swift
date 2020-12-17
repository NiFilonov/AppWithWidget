//
//  ViewController.swift
//  AppWithWidget
//
//  Created by Dragonborn on 17.12.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputCountField: UITextField!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func addAction(_ sender: Any) {
        
    }
    
    private func setupUI() {
        messageContainer.layer.cornerRadius = 20.0
        addButton.layer.cornerRadius = 20.0
    }
    
}

