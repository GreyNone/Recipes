//
//  FavouritesViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 18.10.23.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var isActive: Bool {
        return searchController.isActive
    }
    var favouritesViewModel: FavouritesViewModel?
    
    //MARK: - Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
        self.navigationItem.title = "Your Favourite Recipes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.title = nil
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK: - Custom Setup
    private func setup() {
        favouritesViewModel = FavouritesViewModel()
        favouritesViewModel?.delegate = self
        favouritesViewModel?.setupData()
                
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "mainColor")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = favouritesViewModel?.scopeBarTitles
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        recipesCollectionView.register(RecipeCollectionViewCell.nib, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        configureHierarchy()
    }
}

//MARK: - FavouritesViewModelDelegate
extension FavouritesViewController: FavouritesViewModelDelegate {
    func reloadCollectionView() {
        recipesCollectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource
extension FavouritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favouritesViewModel?.numberOfItems ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let recipeCollectonViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier,
                                                                                for: indexPath)
                as? RecipeCollectionViewCell else { return RecipeCollectionViewCell() }
        
        if let favouritesViewModel = favouritesViewModel {
            recipeCollectonViewCell.configure(data: favouritesViewModel.getInfo(for: indexPath))
        }
        
        return recipeCollectonViewCell
    }
}

//MARK: - UICollectionViewDelegate
extension FavouritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.favouritesViewModel?.selectedRecipeCell = collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell
        
        self.navigationController?.pushViewController(DetailViewController.makeDetailViewController(recipe: favouritesViewModel?.selectedRecipe(indexPath: indexPath)), animated: true)
    }
}

//MARK: - UICollectionViewCompositionalLayout
extension FavouritesViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0)
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                 heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = contentInsets
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                            heightDimension: .fractionalHeight(0.5)),
                                                         subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    
    func configureHierarchy() {
        recipesCollectionView.collectionViewLayout = createLayout()
    }
}

extension FavouritesViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return AnimationController(animationDuration: 0.5,
                                       animationType: .present,
                                       startingPoint: recipesCollectionView.convert(favouritesViewModel?.selectedRecipeCell?.center ?? CGPoint(),
                                                                                    to: view),
                                       selectedCellSize: favouritesViewModel?.selectedRecipeCell?.frame.size ?? CGSize(width: 200, height: 200))
        } else if operation == .pop {
            return AnimationController(animationDuration: 0.5,
                                       animationType: .dismiss,
                                       startingPoint: recipesCollectionView.convert(favouritesViewModel?.selectedRecipeCell?.center ?? CGPoint(),
                                                                                    to: view),
                                       selectedCellSize: favouritesViewModel?.selectedRecipeCell?.frame.size ?? CGSize(width: 200, height: 200))
        }
        
        return nil
    }
}

//MARK: - UISearchResultsUpdating
extension FavouritesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
              let scope = searchController.searchBar.scopeButtonTitles?[searchController.searchBar.selectedScopeButtonIndex] else { return }
        favouritesViewModel?.filterContentForSearchQuery(searchQuery: searchQuery, scope: scope, isActive: isActive)
    }
}

//MARK: - UISearchBarDelegate
extension FavouritesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchQuery = searchBar.text,
              let scope = searchBar.scopeButtonTitles?[selectedScope] else { return }
        favouritesViewModel?.filterContentForSearchQuery(searchQuery: searchQuery, scope: scope, isActive: isActive)
    }
}
