//
//  ViewController.swift
//  KucherenkoReddit
//
//  Created by Daniil on 10.02.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var savedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onChangeSave(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
}

#Preview {
    return ViewController()
}

