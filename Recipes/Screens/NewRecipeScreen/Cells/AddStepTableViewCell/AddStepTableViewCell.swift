//
//  AddStepTableViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 1.02.24.
//

import UIKit

class AddStepTableViewCell: UITableViewCell {

    static let identifier = "AddStepTableViewCell"
    static var nib: UINib {
        return UINib(nibName: "AddStepTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
