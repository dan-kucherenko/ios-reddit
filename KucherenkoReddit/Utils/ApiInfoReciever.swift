//
//  ApiInfoReciever.swift
//  KucherenkoReddit
//
//  Created by Daniil on 11.02.2024.
//

import Foundation

struct ApiInfoReciever {
    private func getInfo() async -> ApiResponsePost? {
        let endPoint = "https://www.reddit.com/r/ios/top.json?limit=2"
        guard let url = URL(string: endPoint) else {
            print("Error in creating URL")
            return nil
        }
        
        var data: Data?
        var apiPost: ApiResponsePost?
        do {
            let (apiData, _) = try await URLSession.shared.data(from: url)
            data = apiData
        } catch {
            print("Error getting the data from api")
        }
        
        guard let data else {print("Data is nil"); return nil}
        
        do {
            let decoder = JSONDecoder()
            apiPost = try decoder.decode(ApiResponsePost.self, from: data)
        } catch {
            print("Error, while decoding the response")
        }
        return apiPost
    }
    
    func getPosts() async -> [Post] {
        let apiResponsePosts = await self.getInfo()
        var posts: [Post] = []
    
        guard let apiResponsePosts else { return [] }
        apiResponsePosts.data.children.forEach{
            posts.append(Post(from: $0.data))
        }
        
        return posts
    }
}
