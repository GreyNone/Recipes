//
//  CustomTabBar.swift
//  Recipes
//
//  Created by Александр Василевич on 18.10.23.
//

import UIKit

class CustomTabBar: UITabBar {

    var shapeLayer: CALayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 30,
                                                      y: 0,
                                                      width: self.bounds.width - 60,
                                                      height: self.bounds.height),
                                  cornerRadius: (self.frame.width / 2)).cgPath

        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 2)
        shapeLayer.shadowRadius = 5.0
        shapeLayer.shadowOpacity = 0.8
        shapeLayer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 30,
                                                                 y: 0,
                                                                 width: self.bounds.width - 60,
                                                                 height: self.bounds.height),
                                             cornerRadius: (self.frame.width / 2)).cgPath
        shapeLayer.fillColor = UIColor.white.cgColor

        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
        
        if let items = self.items {
            items.forEach { item in item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
            }
        }
        self.itemPositioning = .centered
    }
}
