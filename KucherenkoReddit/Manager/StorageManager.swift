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
    
    func savePost(_ post: Post) {
        var savedPosts = getSavedPosts()
        if savedPosts.contains(post) {
            savedPosts.removeAll(where: { post.postName == $0.postName })
        } else {
            savedPosts.append(post)
        }
        
        do {
            let encodedPosts = try JSONEncoder().encode(savedPosts)
            try encodedPosts.write(to: savedPostsFile, options: .atomic)
        } catch {
            print("Error saving post: \(error)")
        }
    }
    
    func getSavedPosts() -> [Post] {
        guard FileManager.default.fileExists(atPath: savedPostsFile.path()),
            let postsData = FileManager.default.contents(atPath: savedPostsFile.path())
        else { return [] }
        return (try? JSONDecoder().decode([Post].self, from: postsData)) ?? []
    }
}
