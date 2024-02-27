//
//  StorageManager.swift
//  KucherenkoReddit
//
//  Created by Daniil on 26.02.2024.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let savedPostsFile = URL.documentsDirectory.appending(path: "savedPosts.json")
    
    private init() {}
    
    func togglePostSave(_ post: Post) {
        print(savedPostsFile)
        var savedPosts = getPosts()
        if savedPosts.contains(post) {
            savedPosts.removeAll(where: { post.title == $0.title })
        } else {
            savedPosts.append(post)
        }
        
        print(savedPosts.count)
        guard let encodedPosts = try? JSONEncoder().encode(savedPosts) else { return }
        try? encodedPosts.write(to: savedPostsFile, options: .atomic)
    }
    
    func getPosts() -> [Post] {
        guard
            FileManager.default.fileExists(atPath: savedPostsFile.path()),
            let postsData = FileManager.default.contents(atPath: savedPostsFile.path())
        else {
            return []
        }
        return (try? JSONDecoder().decode([Post].self, from: postsData)) ?? []
    }
}
