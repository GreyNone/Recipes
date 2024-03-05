//
//  FavouritesViewModel.swift
//  Recipes
//
//  Created by Александр Василевич on 12.11.23.
//

import UIKit

final class FavouritesViewModel {
    
    private enum Categories: String, CaseIterable {
        case favourite = "Favourite"
        case createdRecipes = "Your Recipes"
    }
    
    weak var delegate: FavouritesViewModelDelegate?
    let scopeBarTitles = [Categories.favourite.rawValue, Categories.createdRecipes.rawValue]
    var favouritesRecipes = [MockData.mockRecipe, MockData.mockRecipe,MockData.mockRecipe,MockData.mockRecipe,MockData.mockRecipe]
    var createdRecipes = [MockData.mockRecipe,MockData.mockRecipe]
    var filteredRecipes = [Recipe]()
    var selectedRecipeCell: RecipeCollectionViewCell?
}

extension FavouritesViewModel {
    func setupData() {
        filteredRecipes = favouritesRecipes
        delegate?.reloadCollectionView()
    }
}

//MARK: - UICollectionViewDataSource
extension FavouritesViewModel {
    var numberOfItems: Int {
        filteredRecipes.count
    }
    
    func getInfo(for indexPath: IndexPath) -> (image: String?, savedImage: UIImage?, title: String?, readyInMinutes: Int?) {
        let recipe = filteredRecipes[indexPath.row]
        return (image: recipe.image, recipe.savedImage, recipe.title, recipe.readyInMinutes)
    }
    
    func selectedRecipe(indexPath: IndexPath) -> Recipe {
        filteredRecipes[indexPath.row]
    }
}

//MARK: - UISearchBarDelegate && UISearchResultsUpdating
extension FavouritesViewModel {
    func filterContentForSearchQuery(searchQuery: String, scope: String?, isActive: Bool) {
        let category = Categories.allCases.first { category in
            category.rawValue == scope
        }
        
        switch category {
        case .favourite:
            if searchQuery.isEmpty && isActive {
                return
            } else if searchQuery.isEmpty && !isActive {
                filteredRecipes = favouritesRecipes
                delegate?.reloadCollectionView()
                return
            }
            
            filteredRecipes = favouritesRecipes.filter({ recipe in
                guard let title = recipe.title else { return false }
                
                return title.lowercased().contains(searchQuery.lowercased())
            })
            delegate?.reloadCollectionView()
            
        case .createdRecipes:
            if searchQuery.isEmpty && isActive {
                return
            } else if searchQuery.isEmpty && !isActive {
                filteredRecipes = createdRecipes
                delegate?.reloadCollectionView()
                return
            }
            
            filteredRecipes = createdRecipes.filter({ recipe in
                guard let title = recipe.title else { return false }
                
                return title.lowercased().contains(searchQuery.lowercased())
            })
            delegate?.reloadCollectionView()
            
        case .none:
            filteredRecipes = favouritesRecipes
            delegate?.reloadCollectionView()
        }
    }
}
