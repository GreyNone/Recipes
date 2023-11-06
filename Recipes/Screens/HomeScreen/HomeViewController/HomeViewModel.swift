//
//  HomeViewModel.swift
//  Recipes
//
//  Created by Александр Василевич on 23.10.23.
//

import Foundation
import UIKit

final class HomeViewModel {
    weak var delegate: RequestDelegate?
    private var state: ViewState {
        didSet {
            delegate?.didUpdate(with: state)
        }
    }
    var allRecipes = [Recipe]()
//    var allRecipes = [MockData.mockRecipe, MockData.mockRecipe,MockData.mockRecipe,MockData.mockRecipe,MockData.mockRecipe]
    var filteredRecipes = [Recipe]()
    
    init() {
        self.state = .idle
    }
}

//MARK: - Network
extension HomeViewModel {
    func loadData() {
        state = .loading
        NetworkManager.shared.loadRecipes { [weak self] (recipes, viewState) in
            guard let self = self else { return }
            if let recipes = recipes {
                for var recipe in recipes {
                    recipe.appendFilterCases()
                    self.allRecipes.append(recipe)
                }
                self.filteredRecipes = allRecipes
                self.state = viewState
            } else {
                self.state = viewState
            }
            
        }
//        self.filteredRecipes = self.allRecipes
//        self.state = .success(nil)
    }
    
    func loadIfNeeded(for indexPath: IndexPath) {
        let currentItem = indexPath.row
        if currentItem >= allRecipes.count - 2 {
            loadData()
        }
    }
}

//MARK: - EmptyStatusView
extension HomeViewModel {
    func didTapOnButton() {
        self.loadData()
    }
}

//MARK: - CollectionViewData
extension HomeViewModel {
    var numberOfItems: Int {
        filteredRecipes.count
    }
    
    func getInfo(for indexPath: IndexPath) -> (image: String?, title: String?, readyInMinutes: Int?) {
        let recipe = filteredRecipes[indexPath.row]
        return (image: recipe.image, recipe.title, recipe.readyInMinutes)
    }
    
    func selectedRecipe(indexPath: IndexPath) -> Recipe {
        filteredRecipes[indexPath.row]
    }
    
    func filterData() {
        self.state = .loading
        
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
            self.state = .success(nil)
            return
        }
        
        filteredRecipes = allRecipes.filter({ $0.filterCases.contains(checkedFilterCases) })
    
        self.state = .success(nil)
    }
}

//MARK: - CollectionViewLayout
extension HomeViewModel {
    private var columns: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 3
        case .phone:
            return 2
        default:
            return 1
        }
    }
    var insets: UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    var minimumLineSpacingForSection: CGFloat {
        10
    }
    var minimumInteritemSpacingForSection: CGFloat {
        10
    }
    
    func calculateItemWidth(collectionWidth: CGFloat) -> CGSize {
        let totalSpace = insets.left + insets.right + (minimumInteritemSpacingForSection * CGFloat(columns - 1))
        let size = Int((collectionWidth - totalSpace) / CGFloat(columns))
        return CGSize(width: size, height: 300)
    }
}
