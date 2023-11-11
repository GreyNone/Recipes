//
//  StepTableViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 9.11.23.
//

import UIKit

class StepTableViewCell: UITableViewCell {

    static let identifier = "StepTableViewCell"
    static var nib: UINib {
        UINib(nibName: "StepTableViewCell", bundle: nil)
    }
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(data: (length: String, description: String)?) {
        lengthLabel.text = data?.length
        titleLabel.text = data?.description
    }
}
