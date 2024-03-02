//
//  PostDetailViewController.swift
//  KucherenkoReddit
//
//  Created by Daniil on 10.02.2024.

import UIKit
import SDWebImage

class PostDetailViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var postDetailView: PostView!
    
    weak var selectionDelegate: PostSelectionDelegate?
    weak var savedStateDelegate: SavedStateDelegate?
    
    // MARK: Const
    struct Const {
        static let cellIdentifier = "post"
        static let defaultSubreddit = "r/SteamDeck"
        static let gotoDetailViewSegueId = "go_to_post_detail"
        static let savedBtnImage = "bookmark.circle.fill"
        static let defaultBtnImage = "bookmark.circle"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View is loaded")
        postDetailView.shareBtnDelegate = self
        postDetailView.saveBtnDelegate = self
        config(post: selectionDelegate?.selectedPost)
    }
    
    func config(post: Post?) {
        guard let post else { return }
        postDetailView.config(post: post)
        print(post)
    }
    
    private func updateSavedButtonImage() {
        postDetailView.setSavedImage()
    }
}

extension PostDetailViewController: ShareButtonDelegate {
    func shareButtonClicked() {
        guard let url = postDetailView.post?.permalink else { return }
        let items = [URL(string: url)!]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

extension PostDetailViewController: SavedButtonDelegate {
    func saveButtonClicked() {
        savedStateDelegate?.didChangeSavedState(for: postDetailView)
    }
}
