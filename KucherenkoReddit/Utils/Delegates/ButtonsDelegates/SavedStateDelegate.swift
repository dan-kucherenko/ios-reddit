//
//  SaveChangedDelegate.swift
//  KucherenkoReddit
//
//  Created by Daniil on 27.02.2024.
//

import Foundation

protocol SavedStateDelegate: AnyObject {
    func didChangeSavedState(for postView: PostView)
}
