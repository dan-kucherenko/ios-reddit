//
//  ShareButtonListDelegate.swift
//  KucherenkoReddit
//
//  Created by Daniil on 26.02.2024.
//

import Foundation

protocol ShareButtonListDelegate: AnyObject {
    func shareButtonClicked(postView: PostView)
}
