//
//  EmptyStatusView.swift
//  Recipes
//
//  Created by Александр Василевич on 2.11.23.
//

import UIKit

class EmptyStatusView: UIView {
    
    @IBOutlet var containerView: UIView!
    weak var delegate: EmptyStatusViewProtocol?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @IBAction func didTapOnButton(_ sender: Any) {
        delegate?.didTapOnButton()
    }
    
    private func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("EmptyStatusView", owner: self)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}

