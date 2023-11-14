//
//  FavouritesViewModel.swift
//  Recipes
//
//  Created by Александр Василевич on 12.11.23.
//

import UIKit

final class FavouritesViewModel {
    
    weak var delegate: FavouritesViewModelDelegate?
    var favouritesRecipes = [MockData.mockRecipe, MockData.mockRecipe,MockData.mockRecipe,MockData.mockRecipe,MockData.mockRecipe]
}

//MARK: - UICollectionViewDataSource
extension FavouritesViewModel {
    var numberOfItems: Int {
        favouritesRecipes.count
    }
    
    func getInfo(for indexPath: IndexPath) -> (image: String?, savedImage: UIImage?, title: String?, readyInMinutes: Int?) {
        let recipe = favouritesRecipes[indexPath.row]
        return (image: recipe.image, recipe.savedImage, recipe.title, recipe.readyInMinutes)
    }
    
    func selectedRecipe(indexPath: IndexPath) -> Recipe {
        favouritesRecipes[indexPath.row]
    }
}