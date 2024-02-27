//
//  PostSelectionDelegate.swift
//  KucherenkoReddit
//
//  Created by Daniil on 20.02.2024.
//

import Foundation

protocol PostSelectionDelegate: AnyObject {
    var selectedPost: Post? { get }
}
