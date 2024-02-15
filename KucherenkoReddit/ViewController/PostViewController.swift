//
//  ViewController.swift
//  KucherenkoReddit
//
//  Created by Daniil on 10.02.2024.

import UIKit
import SDWebImage

class PostViewController: UIViewController {
    private let api = ApiInfoReciever()
    private var post: Post?
    
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var postTime: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var savedButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var comments: UIButton!
    @IBOutlet private weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            post = await api.getPosts()[0]
            setViewElements(post: post)
        }
    }
    
    @IBAction func onChangeSave(_ sender: UIButton) {
        post?.saved.toggle()
        guard let saved = post?.saved else {return}
        print(saved)
        if saved {
            setImage(image: "bookmark.fill")
        } else {
            setImage(image: "bookmark")
        }
    }
    
    private func setViewElements(post: Post?) {
        guard let post else { return }
        self.author.text = post.author
        self.postTime.text = convertTime(post.createdUtc)
        self.domain.text = post.domain
        self.titleLabel.text = post.title
        self.savedButton.isSelected = post.saved
        manageUrl(url: post.url)
        self.rating.setTitle(String(post.score), for: .normal)
        self.comments.setTitle(String(post.numComments), for: .normal)
        
        let savedBtnImageStr = savedButton.isSelected ? "bookmark.fill" : "bookmark"
        setImage(image: savedBtnImageStr)
    }
    
    private func convertTime(_ createdUtc: Int) -> String {
        let created = Date(timeIntervalSince1970: TimeInterval(createdUtc))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let dateStr = formatter.localizedString(for: created, relativeTo: Date())
        return dateStr
    }
    
    private func manageUrl(url: String?) {
        guard let url else {
            self.image.image = UIImage(resource: .franks)
            return
        }
        self.image.sd_setImage(with: URL(string: url))
    }
    
    private func setImage(image: String) {
        let config = UIImage.SymbolConfiguration(scale: .medium)
        self.savedButton.setImage(UIImage(systemName: image, withConfiguration: config), for: .normal)
    }
}
