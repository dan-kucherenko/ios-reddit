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
    private var imageView: UIView?
    
    weak var shareBtnDelegate: ShareButtonDelegate?
    weak var sharedBtnListDelegate: ShareButtonListDelegate?
    weak var saveBtnDelegate: SavedButtonDelegate?
    weak var savedStateDelegate: SavedStateDelegate?
    weak var commentsBtnDelegate: CommentButtonDelegate?
    
    // MARK: Outlets
    @IBOutlet var postView: UIView!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var postTime: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var savedButton: UIButton!
    @IBOutlet private weak var viewImage: UIImageView!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var comments: UIButton!
    @IBOutlet private weak var share: UIButton!
    
    // MARK: Constants
    struct Const {
        static let savedBtnImage = "bookmark.fill"
        static let defaultBtnImage = "bookmark"
    }
    let kCONTENT_XIB_NAME = "PostView"
    
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
    
    // MARK: Outlet action
    @IBAction func onSaveClicked(_ sender: UIButton) {
        saveBtnDelegate?.saveButtonClicked()
        savedStateDelegate?.didChangeSavedState(for: self)
    }
    
    @IBAction func onCommentsClicked(_ sender: Any) {
        commentsBtnDelegate?.commentClicked(on: self)
    }
    
    @IBAction func onShareClicked(_ sender: Any) {
        shareBtnDelegate?.shareButtonClicked()
        sharedBtnListDelegate?.shareButtonClicked(postView: self)
    }
    
    // MARK: config methods
    func config(post: Post?) {
        guard let post else { return }
        self.post = post
        self.author.text = post.author
        self.postTime.text = convertTime(post.createdUtc)
        self.domain.text = post.domain
        self.titleLabel.text = post.title
        self.savedButton.isSelected = post.saved
        manageUrl(url: post.url)
        self.rating.setTitle(String(post.score), for: .normal)
        self.comments.setTitle(String(post.numComments), for: .normal)
        
        let savedBtnImageStr = savedButton.isSelected ? Const.savedBtnImage : Const.defaultBtnImage
        setImage(image: savedBtnImageStr)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        recognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(recognizer)
        imageView = UIView(
            frame: CGRect(
                x: postView.bounds.midX - 75,
                y: postView.bounds.midY - 100,
                width: 150,
                height: 200
            )
        )
        if let imageView = self.imageView {
            BookmarkDrawer.shared.drawBookmark(for: imageView, in: self, postView: postView)
        }
    }
    
    // MARK: bookmarks icon changing
    func setSavedImage() {
        setImage(image: Const.savedBtnImage)
    }
    
    func setUnsavedImage() {
        setImage(image: Const.defaultBtnImage)
    }
    
    @objc private func doubleTapped (_ sender: UITapGestureRecognizer) {
        guard let imageView = self.imageView else { return }

        UIView.transition(
            with: self,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    imageView.isHidden = false
                },
            completion: { _ in
                UIView.transition(
                    with: self,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: {
                        imageView.isHidden = true
                    }
                )
                self.onSaveClicked(self.savedButton)
            }
        )
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
        let config = UIImage.SymbolConfiguration(scale: .large)
        self.savedButton.setImage(UIImage(systemName: image, withConfiguration: config), for: .normal)
    }
}

extension UIView {
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
