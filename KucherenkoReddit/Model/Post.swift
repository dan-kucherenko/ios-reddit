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
    let url: String
    
    init(from apiChild: ChildData){
        self.author = apiChild.author
        self.createdUtc = apiChild.createdUtc
        self.domain = apiChild.domain
        self.saved = apiChild.saved
        self.title = apiChild.title
        self.score = apiChild.score
        self.numComments = apiChild.numComments
        self.url = apiChild.url.replacingOccurrences(of: "&amp", with: "&")
    }
}
