//
//  Post.swift
//  KucherenkoReddit
//
//  Created by Daniil on 10.02.2024.
//

import Foundation

struct Post {
    let author: String
    let createdUtc: Int
    let domain: String
    let saved: Bool
    let title: String
    let score: Int
    let numComments: Int
    var url: String? = nil
    
    init(from apiChild: ChildData){
        self.author = apiChild.author
        self.createdUtc = apiChild.createdUtc
        self.domain = apiChild.domain
        self.saved = apiChild.saved
        self.title = apiChild.title
        self.score = apiChild.score
        self.numComments = apiChild.numComments
        self.url = manageImageExistence(post: apiChild)
    }
    
    private func manageImageExistence(post: ChildData?) -> String? {
        guard let post else { return nil }
        guard let preview = post.preview else {return nil}
        return preview.enabled ? preview.images.first?.source.url : nil
    }
}
