//
//  Post.swift
//  KucherenkoReddit
//
//  Created by Daniil on 10.02.2024.
//

import Foundation

struct Post: Codable {
    let author: String
    let postName: String
    let createdUtc: Int
    let domain: String
    var saved: Bool
    let title: String
    let score: Int
    let numComments: Int
    var url: String? = nil
    let permalink: String
    
    init(){
        self.author = ""
        self.postName = ""
        self.createdUtc = 0
        self.domain = ""
        self.saved = false
        self.title = ""
        self.score = 0
        self.numComments = 0
        self.permalink = ""
        self.url = nil
    }
    
    init(from apiChild: ChildData){
        self.author = apiChild.author
        self.postName = apiChild.name
        self.createdUtc = apiChild.createdUtc
        self.domain = apiChild.domain
        self.saved = apiChild.saved
        self.title = apiChild.title
        self.score = apiChild.score
        self.numComments = apiChild.numComments
        self.permalink = "https://reddit.com/\(apiChild.permalink)"
        self.url = manageImageExistence(post: apiChild)
    }
    
    private func manageImageExistence(post: ChildData?) -> String? {
        guard let post else { return nil }
        if let url = post.url, url.contains(".jpeg"), url.contains(".jpg") {
            return url
        } else if let preview = post.preview, preview.enabled, let imageUrl = preview.images.first?.source.url {
            return imageUrl.replacingOccurrences(of: "&amp;", with: "&")
        }
        
        return nil
    }
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.postName == rhs.postName
    }
}
