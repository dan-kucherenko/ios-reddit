//
//  PostDetailViewController.swift
//  KucherenkoReddit
//
//  Created by Daniil on 10.02.2024.

import UIKit
import SDWebImage

class PostDetailViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var postDetailView: PostView!
    
    var delegate: PostSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View is loaded")
        config(post: delegate?.selectedPost)
    }
    
    func config(post: Post?) {
        guard let post else { return }
        postDetailView.config(post: post)
    }
}
