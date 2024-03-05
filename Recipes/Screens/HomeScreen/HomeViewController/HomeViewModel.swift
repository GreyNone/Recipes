//
//  HomeViewModel.swift
//  Recipes
//
//  Created by Александр Василевич on 23.10.23.
//

import Foundation
import UIKit

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    var mainRecipes = [Recipe]()
    var searchRecipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    var lastContentOffset: CGFloat = 0
    var selectedRecipeCell: RecipeCollectionViewCell?
}

//MARK: - Network
extension HomeViewModel {
//    func loadData() {
//        delegate?.startActivityIndicator()
//        NetworkManager.shared.loadRecipes { [weak self] (recipes) in
//            guard let self = self else { return }
//            
//            if let recipes = recipes {
//                for var recipe in recipes {
//                    recipe.appendFilterCases()
//                    self.mainRecipes.append(recipe)
//                }
//                self.filteredRecipes = mainRecipes
//                delegate?.stopActivityIndicator()
//                delegate?.reloadCollectionView()
//            } else {
//                delegate?.presentEmptyStatusView()
//            }
//        }
//    }
    
    //Mockdata for test
    func loadData() {
        mainRecipes = [MockData.mockRecipe, MockData.mockRecipe,MockData.mockRecipe, MockData.mockRecipe,MockData.mockRecipe, MockData.mockRecipe, MockData.mockRecipe]
        
        delegate?.startActivityIndicator()
        self.filteredRecipes = self.mainRecipes
        delegate?.stopActivityIndicator()
        delegate?.reloadCollectionView()
    }
    
    func loadSearchRecipes(with searchQuery: String, isActive: Bool) {
        if searchQuery.isEmpty && isActive {
            return
        } else if searchQuery.isEmpty && !isActive {
            filteredRecipes = mainRecipes
            delegate?.reloadCollectionView()
            return
        }
        
        searchRecipes = []
        
        delegate?.startActivityIndicator()
        NetworkManager.shared.loadSearchRecipes(searchQuery: searchQuery) { [weak self] (recipes) in
            guard let self = self else { return }
            
            if let recipes = recipes {
                for var recipe in recipes {
                    recipe.appendFilterCases()
                    searchRecipes.append(recipe)
                }
                filteredRecipes = searchRecipes
                delegate?.stopActivityIndicator()
                delegate?.reloadCollectionView()
            } else {
                delegate?.presentEmptyStatusView()
            }
        }
    }
    
    func pagination(for indexPath: IndexPath, searchQuery: String) {
//        let currentItem = indexPath.row
//        
//        guard searchRecipes.isEmpty else {
//            if currentItem >= searchRecipes.count - 2 {
//                NetworkManager.shared.loadSearchRecipes(searchQuery: searchQuery) { [weak self]  (recipes) in
//                    guard let self = self else { return }
//                    if let recipes = recipes {
//                        for var recipe in recipes {
//                            recipe.appendFilterCases()
//                            
//                            searchRecipes.append(recipe)
//                            filteredRecipes.append(recipe)
//                            
//                            let indexPath = IndexPath(item: self.filteredRecipes.count - 1, section: 0)
//                            delegate?.insertNewElementInCollectionView(at: indexPath)
//                        }
//                    }
//                }
//            }
//            return
//        }
//        
//        if currentItem >= mainRecipes.count - 2 {
//            NetworkManager.shared.loadRecipes { [weak self] (recipes) in
//                guard let self = self else { return }
//                if let recipes = recipes {
//                    for var recipe in recipes {
//                        recipe.appendFilterCases()
//                        
//                        mainRecipes.append(recipe)
//                        filteredRecipes.append(recipe)
//                        
//                        let indexPath = IndexPath(item: self.filteredRecipes.count - 1, section: 0)
//                        delegate?.insertNewElementInCollectionView(at: indexPath)
//                    }
//                }
//            }
//        }
    }
}

//MARK: - EmptyStatusView
extension HomeViewModel {
    func didTapOnButton() {
        delegate?.dismissEmptyStatusView()
        self.loadData()
    }
}

//MARK: - CollectionViewDataSource
extension HomeViewModel {
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
    
    func filterData() {
        filteredRecipes = []
        
        let checkedFilters = FilterData.allData.filter { filter in
            filter.isChecked
        }
        
        var checkedFilterCases = [FilterCases]()
        for checkedFilter in checkedFilters {
            checkedFilterCases.append(checkedFilter.filterCase)
        }
        
        if checkedFilters.isEmpty {
            filteredRecipes = mainRecipes
            delegate?.reloadCollectionView()
            return
        }
        
        filteredRecipes = mainRecipes.filter({ $0.filterCases.contains(checkedFilterCases) })
        delegate?.reloadCollectionView()
    }
}
