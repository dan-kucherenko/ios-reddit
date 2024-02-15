//
//  ApiInfoReciever.swift
//  KucherenkoReddit
//
//  Created by Daniil on 11.02.2024.
//

import Foundation

struct ApiInfoReciever {
    func getPosts() async -> [Post] {
        let apiResponsePosts = await self.getInfoWithParams(subreddit: "r/ios", limit: 1, after: nil)
        print(apiResponsePosts as Any)
        var posts: [Post] = []
        
        guard let apiResponsePosts else { print("Posts are empty"); return [] }
        apiResponsePosts.data.children.forEach{
            posts.append(Post(from: $0.data))
        }
        print(posts)
        return posts
    }
    
    private func getInfoWithParams(subreddit: String, limit: Int, after: String?) async -> ApiResponsePost? {
        let limit = String(limit)
        
        let endPoint = "https://www.reddit.com/" + subreddit + "/top.json"
        guard var composedUrl = URLComponents(string: endPoint) else {
            print("Error in creating URL")
            return nil
        }
        
        composedUrl.queryItems = [
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "after", value: after)
        ]
        
        var data: Data?
        var apiPost: ApiResponsePost?
        guard let url = composedUrl.url else {
            print("Error in creating URL")
            return nil
        }
        print(url)
    
        do {
            let (apiData, _) = try await URLSession.shared.data(from: url)
            data = apiData
        } catch {
            print("Error getting the data from api")
        }
        
        guard let data else {print("Data is nil"); return nil}
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            apiPost = try decoder.decode(ApiResponsePost.self, from: data)
        } catch {
            print("Error, while decoding the response")
        }
        return apiPost
    }
}
