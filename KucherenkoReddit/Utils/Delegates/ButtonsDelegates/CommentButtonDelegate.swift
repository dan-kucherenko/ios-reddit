//
//  CommentButtonDelegate.swift
//  KucherenkoReddit
//
//  Created by Daniil on 04.03.2024.
//

import Foundation

protocol CommentButtonDelegate: AnyObject {
    func commentClicked(on postView: PostView)
}
