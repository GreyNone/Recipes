//
//  AddImageTableViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 29.01.24.
//

import UIKit
import PhotosUI

class AddImageTableViewCell: UITableViewCell {
    
    static let identifier = "AddImageTableViewCell"
    static var nib: UINib {
        return UINib(nibName: "AddImageTableViewCell", bundle: nil)
    }
    @IBOutlet weak var recipeImageView: UIImageView!
    weak var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        recipeImageView.layer.cornerRadius = 10
        recipeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        delegate?.presentZoomViewController(with: (recipeImageView.image ?? UIImage(named: "mockImage"))!)
    }
    
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
extension AddImageTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            delegate?.dismissController()
            return
        }
        
        recipeImageView.image = image
        delegate?.dismissController()
    }
}

//MARK: - PHPickerViewControllerDelegate
extension AddImageTableViewCell: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemprovider = results.first?.itemProvider {
            if itemprovider.canLoadObject(ofClass: UIImage.self) {
                itemprovider.loadObject(ofClass: UIImage.self) { [weak self] image , error  in
                    if let error { print(error) }
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.recipeImageView.image = selectedImage
                        }
                    }
                }
            }
            
        }
    }
}
