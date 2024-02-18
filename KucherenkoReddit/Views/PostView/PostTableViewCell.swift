//
//  PostView.swift
//  KucherenkoReddit
//
//  Created by Daniil on 17.02.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet private weak var postView: PostView!
    func setUp(post: Post) {
        postView.setViewElements(post: post)
    }
}
