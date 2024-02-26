//
//  InstructionTableViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 8.11.23.
//

import UIKit

class InstructionTableViewCell: UITableViewCell {

    static let identifier = "InstructionTableViewCell"
    static var nib: UINib {
        UINib(nibName: "InstructionTableViewCell", bundle: nil)
    }
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var expandableView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        expandableView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(data: (title: String,description: String)) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        chevronImageView.image = UIImage(systemName: "chevron.down")
    }
    
    func setExpandableView() {
        if expandableView.isHidden {
            expandableView.isHidden = false
            self.chevronImageView.image = UIImage(systemName: "chevron.up")
        } else {
            expandableView.isHidden = true
            self.chevronImageView.image = UIImage(systemName: "chevron.down")
        }
    }
}
