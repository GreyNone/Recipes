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

//MARK: - CollectionViewLayout
extension DetailViewModel {
    var insets: UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    var minimumLineSpacingForSection: CGFloat {
        10
    }
    var minimumInteritemSpacingForSection: CGFloat {
        10
    }
    var itemSize: CGSize {
        CGSize(width: 150, height: 200)
    }
    
}

//MARK: - UITableViewDataSource
extension DetailViewModel {
    
}
