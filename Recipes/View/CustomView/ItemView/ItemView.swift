//
//  Item View.swift
//  Recipes
//
//  Created by Александр Василевич on 30.10.23.
//

import UIKit

class ItemView: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, image: UIImage, tintColor: UIColor) {
        titleLabel.text = title
        imageView.image = image
        imageView.tintColor = tintColor
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("ItemView", owner: self)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}


