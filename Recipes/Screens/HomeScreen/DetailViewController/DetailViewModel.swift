//
//  DetailViewModel.swift
//  Recipes
//
//  Created by Александр Василевич on 25.10.23.
//

import UIKit

final class DetailViewModel {
    
    weak var delegate: RequestDelegate?
    private var state: ViewState {
        didSet {
            delegate?.didUpdate(with: state)
        }
    }
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.state = .idle
    }
}

//MARK: - Network
extension DetailViewModel {
    
    func loadImage() {
        self.state = .loading
        _ = NetworkManager.shared.loadImage(imageString: recipe.image) { [weak self] image in
            if let self = self,
               let image = image {
                self.state = .success(image)
            } else {
                self?.state = .error
            }
        }
    }
}

//MARK: - CollectionViewData
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
