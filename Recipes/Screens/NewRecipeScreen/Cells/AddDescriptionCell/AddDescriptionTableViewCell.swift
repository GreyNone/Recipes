//
//  AddDescriptionTableViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 29.01.24.
//

import UIKit

class AddDescriptionTableViewCell: UITableViewCell {

    static let identifier = "AddDescriptionTableViewCell"
    static var nib: UINib {
        return UINib(nibName: "AddDescriptionTableViewCell", bundle: nil)
    }
    weak var delegate: TableViewCellDelegate?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        textViewSetup()
    }
    
    private func textViewSetup() {
        textView.delegate = self
        
        textView.text = "Placeholder"
        textView.textColor = UIColor(named: "mainTextColor")!.withAlphaComponent(0.4)
        
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK: - UITextViewDelegate
extension AddDescriptionTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textViewHeightConstraint.constant = size.height

        delegate?.updateTableView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text == "\n" else { return true }
        
        textView.resignFirstResponder()
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "mainTextColor")!.withAlphaComponent(0.4) {
            textView.text = nil
            textView.textColor = UIColor(named: "mainTextColor")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor(named: "mainTextColor")!.withAlphaComponent(0.4)
        }
    }
}

