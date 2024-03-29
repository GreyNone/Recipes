//
//  HomeViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 18.10.23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var emptyStatusView: EmptyStatusView?
    private var searchController = UISearchController(searchResultsController: nil)
    private var isActive: Bool {
        return searchController.isActive
    }
    var homeViewModel: HomeViewModel?
    
    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Food Recipes For You"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.title = nil
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    //MARK: - Custom Setup
    private func setup() {
        self.homeViewModel = HomeViewModel()
        self.homeViewModel?.delegate = self
        self.navigationController?.delegate = self
        
        navigationBarSetup()
        
        recipesCollectionView.register(RecipeCollectionViewCell.nib, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        configureHierarchy()
        
        self.homeViewModel?.loadData()
    }
    
    private func navigationBarSetup() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "mainColor")
        
        searchController.delegate = self
//        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search For Recipes"
        self.navigationItem.searchController = searchController
        
        let likeBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(didTapOnFilterButton))
        likeBarButtonItem.tintColor = UIColor(named: "mainColor")
        self.navigationItem.rightBarButtonItem = likeBarButtonItem
    }
    
    //MARK: - Actions
    @objc private func didTapOnFilterButton() {
        let filterViewStoryboard = UIStoryboard(name: "FilterViewStoryboard", bundle: nil)
        let filterViewController = filterViewStoryboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        filterViewController.delegate = self
        
        if let sheetPresentationController = filterViewController.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
        
        self.present(filterViewController, animated: true)
    }
}

//MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    
    func reloadCollectionView() {
        recipesCollectionView.reloadData()
    }
    
    func insertNewElementInCollectionView(at indexPath: IndexPath) {
        recipesCollectionView.performBatchUpdates { [weak self] in
            self?.recipesCollectionView.insertItems(at: [indexPath])
        }
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func presentEmptyStatusView() {
        emptyStatusView = EmptyStatusView()
        if let emptyStatusView = emptyStatusView {
            view.addSubview(emptyStatusView)
            emptyStatusView.delegate = self
            addConsraintsToEmptyStatusView()
        }
    }
    
    func dismissEmptyStatusView() {
        emptyStatusView?.removeFromSuperview()
//        emptyStatusView = nil
    }
}

//MARK: - EmptyStatusView
extension HomeViewController: EmptyStatusViewProtocol {
    
    private func addConsraintsToEmptyStatusView() {
        if let emptyStatusView = emptyStatusView {
            emptyStatusView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyStatusView.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                emptyStatusView.containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                emptyStatusView.containerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                emptyStatusView.containerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ])
        }
    }
    
    func didTapOnButton() {
        homeViewModel?.didTapOnButton()
    }
}

//MARK: - FilterDataProtocol
extension HomeViewController: FilterDataProtocol {
    func perfomUpdates() {
        homeViewModel?.filterData()
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let recipeCollectonViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier,
                                                                                for: indexPath)
                as? RecipeCollectionViewCell else { return RecipeCollectionViewCell() }
        
        if let homeViewModel = homeViewModel {
            recipeCollectonViewCell.configure(data: homeViewModel.getInfo(for: indexPath))
        }
        
        return recipeCollectonViewCell
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.homeViewModel?.selectedRecipeCell = collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell
        
        let detailViewController = DetailViewController.makeDetailViewController(recipe: homeViewModel?.selectedRecipe(indexPath: indexPath))
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let searchQuery = searchController.searchBar.text else { return }
        homeViewModel?.pagination(for: indexPath, searchQuery: searchQuery )
    }
}

//MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {

}

//MARK: - UICollectionViewCompositionalLayout
extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let interGroupSpacing = 5.0
            let contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
            
            let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                                        heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = contentInsets
            
            let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                                         heightDimension: .fractionalHeight(1.0)))
            trailingItem.contentInsets = contentInsets

            let topNestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                       heightDimension: .fractionalHeight(0.5)),
                                                                    subitems: [leadingItem, trailingItem])
            
            let bottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                       heightDimension: .fractionalHeight(0.5)))
            bottomItem.contentInsets = contentInsets

            let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                  heightDimension: .fractionalHeight(1.0)),
                                                               subitems: [topNestedGroup, bottomItem])
            
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.interGroupSpacing = interGroupSpacing
            return section
        }
        return layout
    }

    private func configureHierarchy() {
        recipesCollectionView.collectionViewLayout = createLayout()
    }
}

//MARK: - UINavigationControllerDelegate
extension HomeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return AnimationController(animationDuration: 0.5,
                                       animationType: .present,
                                       startingPoint: recipesCollectionView.convert(homeViewModel?.selectedRecipeCell?.center ?? CGPoint(),
                                                                                    to: view),
                                       selectedCellSize: homeViewModel?.selectedRecipeCell?.frame.size ?? CGSize(width: 200, height: 200))
        } else if operation == .pop {
            return AnimationController(animationDuration: 0.5,
                                       animationType: .dismiss,
                                       startingPoint: recipesCollectionView.convert(homeViewModel?.selectedRecipeCell?.center ?? CGPoint(),
                                                                                    to: view),
                                       selectedCellSize: homeViewModel?.selectedRecipeCell?.frame.size ?? CGSize(width: 200, height: 200))
        }
        
        return nil
    }
}

//MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text else { return }
        
        homeViewModel?.loadSearchRecipes(with: searchQuery, isActive: isActive)
    }
}

extension HomeViewController: UISearchControllerDelegate {
    
}

