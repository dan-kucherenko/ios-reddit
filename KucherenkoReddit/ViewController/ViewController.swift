//
//  ViewController.swift
//  KucherenkoReddit
//
//  Created by Daniil on 10.02.2024.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var savedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onChangeSave(_ sender: UIButton) {
        sender.isSelected.toggle()
        let config = UIImage.SymbolConfiguration(scale: .medium)
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: config), for: .normal)
            
            
        } else {
            sender.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
        }
    }
}
