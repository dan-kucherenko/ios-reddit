//
//  PostListViewController.swift
//  KucherenkoReddit
//
//  Created by Daniil on 15.02.2024.
//

import UIKit

class PostListViewController: UIViewController, PostSelectionDelegate {
    // MARK: Outlets
    @IBOutlet private weak var postsTable: UITableView!
    @IBOutlet private weak var subredditLbl: UILabel!
    
    // MARK: Const
    struct Const {
        static let cellIdentifier = "post"
        static let defaultSubreddit = "r/ios"
        static let gotoDetailViewSegueId = "go_to_post_detail"
    }
    
    // MARK: Variables
    private var isLastPost = false
    private var isLoadingData = false
    private let api = ApiInfoReciever()
    private var posts = [Post?]()
    private var lastSelectedPost: Post?
    var selectedPost: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            self.posts = await api.getPosts(subreddit: Const.defaultSubreddit)
            self.subredditLbl.text = Const.defaultSubreddit
            self.postsTable.reloadData()
        }
    }   
}



// MARK: UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Const.cellIdentifier,
            for: indexPath) as! PostTableViewCell
        guard let post = posts[indexPath.row] else {return cell}
        cell.config(post: post)
        return cell
    }
}

// MARK: UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case Const.gotoDetailViewSegueId:
            let nextVc = segue.destination as! PostDetailViewController
            nextVc.delegate = self
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPost = self.posts[indexPath.row]
        self.performSegue(withIdentifier: Const.gotoDetailViewSegueId, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let lastPost = posts.last {
            self.lastSelectedPost = lastPost
        }
        
        if !isLoadingData && !isLastPost {
            if let visibleIndexPaths = postsTable.indexPathsForVisibleRows,
               let lastIndex = visibleIndexPaths.last {
                
                let numberOfRows = postsTable.numberOfRows(inSection: 0)
                
                if lastIndex.row >= numberOfRows - 4 {
                    self.isLoadingData = true
                    print("Data is loading for last post: \(lastIndex.row)")
                    loadPosts(after: lastSelectedPost?.postName)
                }
            }
        }
    }
    
    private func loadPosts(after: String?) {
        guard let after else {return}
        Task {
            let newPosts = await api.getPosts(subreddit: Const.defaultSubreddit, after: after)
            guard !newPosts.isEmpty else {
                self.isLastPost = true
                return
            }
            self.posts.append(contentsOf: newPosts)
            
            DispatchQueue.main.async {
                self.lastSelectedPost = self.posts.last ?? nil
                self.postsTable.reloadData()
                self.isLoadingData = false
            }
        }
    }
}

