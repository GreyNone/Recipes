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
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
