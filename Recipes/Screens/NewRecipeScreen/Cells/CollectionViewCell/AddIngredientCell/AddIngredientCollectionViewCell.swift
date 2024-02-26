//
//  AddIngredientCollectionViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 30.01.24.
//

import UIKit
import PhotosUI

class AddIngredientCollectionViewCell: UICollectionViewCell {

    static let identifier = "AddIngredientCollectionViewCell"
    static var nib: UINib {
        return UINib(nibName: "AddIngredientCollectionViewCell", bundle: nil)
    }
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var ingredientAmountTextField: UITextField!
    @IBOutlet weak var ingredientUnitTextField: UITextField!
    weak var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerStackView.layer.cornerRadius = 10
        containerStackView.layer.borderWidth = 1.0
        containerStackView.layer.borderColor = UIColor.black.cgColor
        
        textFieldSetup()
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognizerAction)))
//        ingredientImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction)))
    }
    
    private func textFieldSetup() {
        ingredientNameTextField.delegate = self
        ingredientAmountTextField.delegate = self
        ingredientUnitTextField.delegate = self
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "mainTextColor")!.withAlphaComponent(0.4)]
        
        var attributedPlaceholder = NSAttributedString(string: "Ingredient Name", attributes: attributes)
        ingredientNameTextField.attributedPlaceholder = attributedPlaceholder
        
        attributedPlaceholder = NSAttributedString(string: "Amount", attributes: attributes)
        ingredientAmountTextField.attributedPlaceholder = attributedPlaceholder
        
        attributedPlaceholder = NSAttributedString(string: "Unit", attributes: attributes)
        ingredientUnitTextField.attributedPlaceholder = attributedPlaceholder
    }
    
    @objc func longPressGestureRecognizerAction(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let alertController = UIAlertController(title: "Warning", message: "Do You Want To Delete This Ingredient?", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (action) in
                guard let self = self else { return }
                
                delegate?.removeItemFromCollectionView(item: self)
            }
            
            let cancelAction = UIAlertAction(title: "No", style: .destructive)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            delegate?.presentController(controller: alertController)
        }
    }
    
//    @objc func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
//        delegate?.presentZoomViewController(with: ingredientImageView.image ?? UIImage(named: "mockImage")!)
//    }
    
    @IBAction func didClickOnAddButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Pick a Photo",
                                                message: "Choose a picture from library or camera",
                                                preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            
            delegate?.presentController(controller: cameraPicker)
        }

        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            let pickerViewController = PHPickerViewController(configuration: configuration)
            pickerViewController.delegate = self
            
            delegate?.presentController(controller: pickerViewController)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        delegate?.presentController(controller: alertController)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddIngredientCollectionViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            delegate?.dismissController()
            return
        }
        
        ingredientImageView.image = image
        delegate?.dismissController()
    }
}

//MARK: - PHPickerViewControllerDelegate
extension AddIngredientCollectionViewCell: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemprovider = results.first?.itemProvider {
            if itemprovider.canLoadObject(ofClass: UIImage.self) {
                itemprovider.loadObject(ofClass: UIImage.self) { [weak self] image , error  in
                    if let error { print(error) }
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.ingredientImageView.image = selectedImage
                        }
                    }
                }
            }
            
        }
    }
}

extension AddIngredientCollectionViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ingredientNameTextField {
            textField.resignFirstResponder()
            ingredientAmountTextField.becomeFirstResponder()
        } else if textField == ingredientAmountTextField {
            textField.resignFirstResponder()
            ingredientUnitTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}

