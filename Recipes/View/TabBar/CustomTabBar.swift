//
//  CustomTabBar.swift
//  Recipes
//
//  Created by Александр Василевич on 18.10.23.
//

import UIKit

class CustomTabBar: UITabBar {
    
    public var didTapOnButton: (() -> ())?
    public lazy var middleButton: UIButton = {
        let middleButton = UIButton()
        var buttonConfiguration = UIButton.Configuration.plain()
        
        middleButton.frame.size = CGSize(width: 50, height: 50)
        
        buttonConfiguration.image = UIImage(systemName: "plus")
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        buttonConfiguration.cornerStyle =
        
        middleButton.backgroundColor = .blue
        middleButton.tintColor = .white
        middleButton.layer.cornerRadius = middleButton.frame.width / 2
        middleButton.configuration = buttonConfiguration
        
        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
        
        self.addSubview(middleButton)
        
        return middleButton
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        self.layer.shadowRadius = 4.0
//        self.layer.shadowOpacity = 0.4
//        self.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        middleButton.center = CGPoint(x: frame.width / 2, y: frame.height / 2 - 20)
    }
    
    @objc func middleButtonAction(sender: UIButton) {
        didTapOnButton?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }
}
