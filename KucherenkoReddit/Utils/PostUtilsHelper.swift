//
//  PostUtilsHelper.swift
//  KucherenkoReddit
//
//  Created by Daniil on 05.03.2024.
//

import Foundation
import UIKit

class PostUtilsHelper {
    static let shared = PostUtilsHelper()
    
    private init(){}
    
    func convertTime(_ createdUtc: Int) -> String {
        let created = Date(timeIntervalSince1970: TimeInterval(createdUtc))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let dateStr = formatter.localizedString(for: created, relativeTo: Date())
        return dateStr
    }
    
    func manageUrl(url: String?, viewImage: UIImageView?) {
        guard let url else {
            viewImage?.image = UIImage(resource: .franks)
            return
        }
        viewImage?.sd_setImage(with: URL(string: url))
    }
    
    func setImage(for savedButton: UIButton?, image: String) {
        let config = UIImage.SymbolConfiguration(scale: .large)
        savedButton?.setImage(UIImage(systemName: image, withConfiguration: config), for: .normal)
    }
}
