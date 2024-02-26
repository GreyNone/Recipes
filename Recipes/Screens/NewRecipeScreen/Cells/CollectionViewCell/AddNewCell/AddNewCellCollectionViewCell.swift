//
//  AddNewCellCollectionViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 30.01.24.
//

import UIKit

class AddNewCellCollectionViewCell: UICollectionViewCell {

    static let identifier = "AddNewCellCollectionViewCell"
    static var nib: UINib {
        return UINib(nibName: "AddNewCellCollectionViewCell", bundle: nil)
    }
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(named: "mainColor")?.cgColor
    }
}
