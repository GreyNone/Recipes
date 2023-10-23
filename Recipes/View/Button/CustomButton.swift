//
//  CustomButton.swift
//  Recipes
//
//  Created by Александр Василевич on 19.10.23.
//

import UIKit

final class CustomButton: UIButton {
    
    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
        }
    }
    
    @IBInspectable var image: UIImage? {
        didSet {
            self.setImage(image, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setup() {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.cornerStyle = .capsule
        self.backgroundColor = .purple
        self.configuration = buttonConfiguration
    }
}
