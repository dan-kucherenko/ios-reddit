//
//  ViewController.swift
//  KucherenkoReddit
//
//  Created by Daniil on 10.02.2024.

import UIKit
import SDWebImage

class ViewController: UIViewController {
    let api = ApiInfoReciever()
    
    @IBOutlet private  weak var author: UILabel!
    @IBOutlet private weak var postTime: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var savedButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var comments: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            let post = await api.getPosts()[0]
            setViewElements(post: post)
        }
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
    }
    
    private func convertTime(_ createdUtc: Int) -> String {
        let created = Date(timeIntervalSince1970: TimeInterval(createdUtc))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let dateStr = formatter.localizedString(for: created, relativeTo: Date())
        return dateStr
    }
    
    func manageUrl(url: String?) {
        guard let url else {
            self.image.image = UIImage(resource: .frank)
            return
        }
        self.image.sd_setImage(with: URL(string: url))
    }
}
