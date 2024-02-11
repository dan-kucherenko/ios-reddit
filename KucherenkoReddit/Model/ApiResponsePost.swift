//
//  ApiPost.swift
//  KucherenkoReddit
//
//  Created by Daniil on 11.02.2024.
//

import Foundation

struct ApiResponsePost: Codable {
    let data: WelcomeData
}

struct WelcomeData: Codable {
    let children: [Child]
}

struct Child: Codable {
    let data: ChildData
}

struct ChildData: Codable {
    let author: String
    let createdUtc: Int
    let domain: String
    let saved: Bool
    let title: String
    let score: Int
    let numComments: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case createdUtc = "created_utc"
        case domain
        case saved
        case title
        case score
        case numComments = "num_comments"
        case url
    }
}
