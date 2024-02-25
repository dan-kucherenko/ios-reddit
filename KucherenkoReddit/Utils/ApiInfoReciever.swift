//
//  ApiInfoReciever.swift
//  KucherenkoReddit
//
//  Created by Daniil on 11.02.2024.
//

import Foundation

struct ApiInfoReciever {
    // MARK: constants
    let defaultEndpoint = "https://www.reddit.com/"
    let endpointTail = "/top.json"
    let limitQueryItem = "limit"
    let afterQueryItem = "after"
    
    
    func getPosts(subreddit: String, after: String = "") async -> [Post] {
        let apiResponsePosts = await self.getInfoWithParams(subreddit: subreddit, limit: 15, after: after)
        var posts: [Post] = []
        
        guard let apiResponsePosts else {
            print("Posts are empty")
            return []
        }
        
        apiResponsePosts.data.children.forEach{
            posts.append(Post(from: $0.data))
        }
        return posts
    }
    
    private func getInfoWithParams(subreddit: String, limit: Int, after: String) async -> ApiResponsePost? {
        let limit = String(limit)
        let endPoint = defaultEndpoint + subreddit + endpointTail
        var post: ApiResponsePost?
        
        guard var composedUrl = URLComponents(string: endPoint) else {
            print("Error in creating URL")
            return nil
        }
        
        composedUrl.queryItems = [
            URLQueryItem(name: limitQueryItem, value: limit),
            URLQueryItem(name: afterQueryItem, value: after)
        ]
        
        guard let url = composedUrl.url else {
            print("Error in creating URL")
            return nil
        }
        print(url)
    
        do {
            let (apiData, _) = try await URLSession.shared.data(from: url)
            post = decodeData(data: apiData)
        } catch {
            print("Error getting the data from api")
        }
            
        return post
    }
    
    
    private func decodeData(data: Data) -> ApiResponsePost? {
        var apiPost: ApiResponsePost?
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
