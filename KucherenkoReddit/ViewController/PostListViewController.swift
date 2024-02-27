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
    @IBOutlet private weak var savedPostsBtn: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UITextField!
    
    // MARK: Const
    struct Const {
        static let cellIdentifier = "post"
        static let defaultSubreddit = "r/SteamDeck"
        static let gotoDetailViewSegueId = "go_to_post_detail"
        static let savedBtnImage = "bookmark.circle.fill"
        static let defaultBtnImage = "bookmark.circle"
    }
    
    // MARK: Variables
    private var isLastPost = false
    private var isLoadingData = false
    private var showSavedPosts = false
    private let api = ApiInfoReciever()
    private let fileManager = FileManager.default
    
    private var posts = [Post?]()
    private var prevPosts = [Post?]()
    private var filteredPosts = [Post?]()
    private var lastSelectedPost: Post?
    
    var selectedPost: Post?
    weak var savedStateDelegate: SavedStateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            self.posts = await api.getPosts(subreddit: Const.defaultSubreddit)
            checkPosts()
            self.subredditLbl.text = Const.defaultSubreddit
            self.searchView.isHidden = true
            self.postsTable.reloadData()
        }
    }
    
    @IBAction func onSavedPostsClicked(_ sender: Any) {
        showSavedPosts.toggle()
        showSavedPosts ? setSavedImage() : setUnsavedImage()
        if showSavedPosts {
            self.searchView.isHidden = false
            self.prevPosts = posts
            self.posts = StorageManager.shared.getSavedPosts()
            postsTable.reloadData()
        } else {
            searchBar.resignFirstResponder()
            self.searchView.isHidden = true
            self.posts = prevPosts
            postsTable.reloadData()
        }
    }
    
    @IBAction func searchBarTextEdited(_ sender: UITextField) {
        if let searchText = sender.text, !searchText.isEmpty {
            posts = StorageManager.shared.getSavedPosts().filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        } else {
            posts = StorageManager.shared.getSavedPosts()
        }
        postsTable.reloadData()
    }
        
    
    private func checkPosts() {
        let savedPosts = StorageManager.shared.getSavedPosts()

        for (index, post) in self.posts.enumerated() {
            if savedPosts.contains(post ?? Post()) {
                if let savedPost = savedPosts.first(where: { $0 == post }) {
                    self.posts[index] = savedPost
                }
            }
        }
    }
    
    private func setSavedImage() {
        setImage(image: Const.savedBtnImage)
    }
    
    private func setUnsavedImage() {
        setImage(image: Const.defaultBtnImage)
    }
    
    private func setImage(image: String) {
        let config = UIImage.SymbolConfiguration(scale: .large)
        self.savedPostsBtn.setImage(UIImage(systemName: image, withConfiguration: config), for: .normal)
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
        
        cell.postView.sharedBtnListDelegate = self
        cell.postView.savedStateDelegate = self
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case Const.gotoDetailViewSegueId:
            let nextVc = segue.destination as! PostDetailViewController
            nextVc.selectionDelegate = self
            nextVc.savedStateDelegate = self
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
        
        if !isLoadingData && !isLastPost && !showSavedPosts {
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
        guard let after else { return }
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


extension PostListViewController: ShareButtonListDelegate {
    func shareButtonClicked(postView: PostView) {
        guard let url = postView.post?.permalink else { return }
        let items = [URL(string: url)!]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

extension PostListViewController: SavedStateDelegate {
    func didChangeSavedState(for postView: PostView) {
        postView.post?.saved.toggle()
    
        guard let saved = postView.post?.saved else { return }
        saved ? postView.setSavedImage() : postView.setUnsavedImage()
        StorageManager.shared.savePost(postView.post ?? Post())
        
        guard let postName = postView.post?.postName else { return }
        
        for (index, post) in posts.enumerated() {
            if post?.postName == postName {
                posts[index]?.saved.toggle()
                let indexPath = IndexPath(row: index, section: 0)
                postsTable.reloadRows(at: [indexPath], with: .automatic)
                break
            }
        }
    }
}
