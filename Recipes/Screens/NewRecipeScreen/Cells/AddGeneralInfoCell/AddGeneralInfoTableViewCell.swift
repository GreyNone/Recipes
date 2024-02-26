//
//  AddGeneralInfoTableViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 29.01.24.
//

import UIKit

class AddGeneralInfoTableViewCell: UITableViewCell {

    static let identifier = "AddGeneralInfoTableViewCell"
    static var nib: UINib {
        return UINib(nibName: "AddGeneralInfoTableViewCell", bundle: nil)
    }
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        textFieldSetup()
    }
    
    private func textFieldSetup() {
        textField.delegate = self
        
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with title: String, textFieldPlaceholder: String) {
        titleLabel.text = title
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "mainTextColor")!.withAlphaComponent(0.4)]
        let attributedPlaceholder = NSAttributedString(string: textFieldPlaceholder, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
    }
}

extension AddGeneralInfoTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}
