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
    
    func drawBookmark(for imageView: UIView, in parentView: UIView, postView: UIView) {
        parentView.addSubview(imageView)
        drawIcon(in: imageView)
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
