//
//  FilterTableViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 25.10.23.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    static let identifier = "FilterTableViewCell"
    static var nib: UINib {
        UINib(nibName: "FilterTableViewCell", bundle: nil)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupTableViewCell(data: (name: String, isChecked: Bool)) {
        titleLabel.text = data.name
        if data.isChecked {
            checkImageView.image = UIImage(systemName: "checkmark")
        } else {
            checkImageView.image = nil
        }
    }
    
    func updateTableViewCell(for indexPath: IndexPath, isChecked: Bool) {
        if isChecked {
            checkImageView.image = nil
        } else {
            checkImageView.image = UIImage(systemName: "checkmark")
        }
    }
}
