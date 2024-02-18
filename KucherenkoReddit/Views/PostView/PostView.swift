//
//  PostView.swift
//  KucherenkoReddit
//
//  Created by Daniil on 18.02.2024.
//

import UIKit
import SDWebImage

class PostView: UIView {
    var post: Post?
    let kCONTENT_XIB_NAME = "PostView"
    @IBOutlet var postView: PostView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet private weak var postTime: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var savedButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var viewImage: UIImageView!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var comments: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        postView.fixInView(self)
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
    
    func setViewElements(post: Post?) {
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
            self.viewImage.image = UIImage(resource: .franks)
            return
        }
        self.viewImage.sd_setImage(with: URL(string: url))
    }
    
    private func setImage(image: String) {
        let config = UIImage.SymbolConfiguration(scale: .medium)
        self.savedButton.setImage(UIImage(systemName: image, withConfiguration: config), for: .normal)
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
