//
//  DetailViewModel.swift
//  Recipes
//
//  Created by Александр Василевич on 25.10.23.
//

import UIKit

final class DetailViewModel {
    
    weak var delegate: DetailViewModelDelegate?
    var recipe: Recipe
    var selectedIndexPath: IndexPath?
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}

//MARK: - UISetup
extension DetailViewModel {
    func setupUI() {
        loadImage()
        
        delegate?.setTitle(text: recipe.title ?? "")
        delegate?.setSummaryText(text: createAttributedString(string: recipe.summary ?? "") ?? NSAttributedString())
    }
    
    private func createAttributedString(string: String) -> NSAttributedString? {
        do {
            let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'Arial'; font-size: \(17)\">%@</span>", string)
            let attributedString = try NSAttributedString(data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                                                   options: [.documentType: NSAttributedString.DocumentType.html,
                                                             .characterEncoding:String.Encoding.utf8.rawValue],
                                                   documentAttributes: nil)
            return attributedString
        } catch {
            print("\(error)")
            return nil
        }
    }
}

//MARK: - Network
extension DetailViewModel {
    private func loadImage() {
        _ = NetworkManager.shared.loadImage(imageString: recipe.image) { [weak self] image in
            if let image = image {
                self?.delegate?.setImage(image: image)
            } else {
                if let mockImage = UIImage(named: "mockImage") {
                    self?.delegate?.setImage(image: mockImage)
                }
            }
        }
    }
}

//MARK: - CollectionViewDataSource
extension DetailViewModel {
    var numberOfItems: Int? {
        recipe.extendedIngredients?.count
    }
    
    func getInfo(for indexPath: IndexPath) -> (title: String?, image: String?, unit: String?, amount: Float?) {
        let ingredient = recipe.extendedIngredients?[indexPath.row]
        return (ingredient?.name, ingredient?.image, ingredient?.unit, ingredient?.amount)
    }
}

//MARK: - UITableViewDataSource
extension DetailViewModel {
    var numberOfSections: Int? {
        recipe.analyzedInstructions?.count
    }
    
    func numberOfItems(for section: Int) -> Int? {
        return (recipe.analyzedInstructions?[section].steps?.count ?? 0) + (selectedIndexPath != nil ? 1 : 0)
    }
    
    func title(for section: Int) -> String? {
        recipe.analyzedInstructions?[section].name
    }
    
    func getStepNumber(for indexPath: IndexPath) -> String? {
        "Step \(recipe.analyzedInstructions?[indexPath.section].steps?[indexPath.row].number ?? 0)"
    }
    
    func getStepInfo(for indexPath: IndexPath) -> (length: String, description: String)? {
        if let selectedIndexPath = selectedIndexPath {
            let step = recipe.analyzedInstructions?[selectedIndexPath.section].steps?[selectedIndexPath.row]
            let length = "\(step?.length?.number ?? 0) " + (step?.length?.unit ?? "minutes")
            return (length, step?.step ?? "")
        }
        return nil
    }
}
