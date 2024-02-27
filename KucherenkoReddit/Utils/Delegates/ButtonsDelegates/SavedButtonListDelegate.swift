//
//  SavedButtonListDelegate.swift
//  KucherenkoReddit
//
//  Created by Daniil on 26.02.2024.
//

import Foundation

protocol SavedButtonListDelegate: AnyObject {
    func savedButtonClicked(postView: PostView)
}
