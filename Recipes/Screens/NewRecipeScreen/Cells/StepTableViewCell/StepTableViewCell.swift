//
//  StepTableViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 1.02.24.
//

import UIKit

class StepTableViewCell: UITableViewCell {

    static let identifier = "StepTableViewCell"
    static var nib: UINib {
        return UINib(nibName: "StepTableViewCell", bundle: nil)
    }
    weak var delegate: TableViewCellDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        textViewSetup()
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognizerAction)))
    }
    
    private func textViewSetup() {
        textView.delegate = self
        
        textView.text = "Placeholder"
        textView.textColor = UIColor(named: "mainTextColor")!.withAlphaComponent(0.4)
        
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func longPressGestureRecognizerAction(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let alertController = UIAlertController(title: "Warning", message: "Do You Want To Delete This Step?", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (action) in
                guard let self = self else { return }
                
                delegate?.removeItemFromTableView(item: self)
            }
            
            let cancelAction = UIAlertAction(title: "No", style: .destructive)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            delegate?.presentController(controller: alertController)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension StepTableViewCell: UITextViewDelegate {
    
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
            textView.textColor = UIColor(named: "mainTextColor" )
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor(named: "mainTextColor")!.withAlphaComponent(0.4)
        }
    }
}
