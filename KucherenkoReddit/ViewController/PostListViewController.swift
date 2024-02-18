//
//  PostListViewController.swift
//  KucherenkoReddit
//
//  Created by Daniil on 15.02.2024.
//

import UIKit

class PostListViewController: UIViewController {
    struct Const {
        static let cellIdentifier = "post"
        static let defaultSubreddit = "r/ios"
        static let gotoDetailViewSegueId = "go_to_post_detail"
    }
    
    @IBOutlet private weak var postsTable: UITableView!
    private let api = ApiInfoReciever()
    private var posts = [Post?]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            posts = await api.getPosts(subreddit: Const.defaultSubreddit, after: nil)
            postsTable.reloadData()
        }
    }
}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Const.cellIdentifier,
            for: indexPath) as! PostTableViewCell
        guard let post = posts[indexPath.row] else {return cell}
        cell.setUp(post: post)
        return cell
    }
}
