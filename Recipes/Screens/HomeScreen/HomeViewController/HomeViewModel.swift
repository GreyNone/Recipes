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
//    var allRecipes = [Recipe]()
    var allRecipes = [MockData.mockRecipe, MockData.mockRecipe,MockData.mockRecipe,MockData.mockRecipe,MockData.mockRecipe]
    var filteredRecipes = [Recipe]()
    
}

//MARK: - Network
extension HomeViewModel {
    func loadData() {
//        delegate?.startActivityIndicator()
//        NetworkManager.shared.loadRecipes { [weak self] (recipes) in
//            guard let self = self else { return }
//            if let recipes = recipes {
//                for var recipe in recipes {
//                    recipe.appendFilterCases()
//                    self.allRecipes.append(recipe)
//                }
//                self.filteredRecipes = allRecipes
//                delegate?.stopActivityIndicator()
//                self.delegate?.updateCollectionView()
//            } else {
//                delegate?.presentEmptyStatusView()
//            }
//        }
        
        delegate?.startActivityIndicator()
        self.filteredRecipes = self.allRecipes
        delegate?.stopActivityIndicator()
        delegate?.updateCollectionView()
    }
    
    func loadIfNeeded(for indexPath: IndexPath) {
//        let currentItem = indexPath.row
//        if currentItem >= allRecipes.count - 2 {
//            NetworkManager.shared.loadRecipes { [weak self] (recipes) in
//                guard let self = self else { return }
//                if let recipes = recipes {
//                    for var recipe in recipes {
//                        recipe.appendFilterCases()
//                        
//                        self.allRecipes.append(recipe)
//                        self.filteredRecipes.append(recipe)
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
            filteredRecipes = allRecipes
            delegate?.updateCollectionView()
            return
        }
        
        filteredRecipes = allRecipes.filter({ $0.filterCases.contains(checkedFilterCases) })
        delegate?.updateCollectionView()
    }
}
