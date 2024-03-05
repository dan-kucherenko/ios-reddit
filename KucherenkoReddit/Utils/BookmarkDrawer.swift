//
//  BookmarkDrawer.swift
//  KucherenkoReddit
//
//  Created by Daniil on 04.03.2024.
//

import Foundation
import UIKit

class BookmarkDrawer {
    static let shared = BookmarkDrawer()
    
    private init(){}
    
    func drawBookmark(for imageView: inout UIView?, in parentView: UIView, postView: UIView) {
        imageView = UIView(
            frame: CGRect(
                x: postView.bounds.midX - 75,
                y: postView.bounds.midY - 100,
                width: 150,
                height: 200
            )
        )
        parentView.addSubview(imageView ?? UIView())
        drawIcon(in: imageView ?? UIView())
    }
    
    private func drawIcon (in view: UIView){
        let path = UIBezierPath()
        let width = view.frame.width / 4
        let height = view.frame.height / 2
        
        path.move(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: width, y: height * 2))
        path.addLine(to: CGPoint(x: width * 2, y: height * 1.75))
        path.addLine(to: CGPoint(x: width * 3, y: height * 2))
        path.addLine(to: CGPoint(x: width * 3, y: height / 2))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.systemYellow.cgColor
        view.layer.addSublayer(shapeLayer)
        view.isHidden = true
    }
}
