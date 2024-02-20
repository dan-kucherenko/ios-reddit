//
//  PostTableViewCell.swift
//  KucherenkoReddit
//
//  Created by Daniil on 17.02.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet private weak var postView: PostView!
    
    func config(post: Post) {
        postView.config(post: post)
    }
}
