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
    let name: String
    let createdUtc: Int
    let domain: String
    let saved: Bool
    let title: String
    let score: Int
    let numComments: Int
    let url: String?
    let preview: Preview?
    struct Preview: Codable {
        let images: [Image]
        let enabled: Bool
    }
    struct Image: Codable {
        let source: Source
    }
    struct Source: Codable {
        let url: String
    }
}
