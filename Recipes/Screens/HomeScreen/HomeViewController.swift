//
//  HomeViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 18.10.23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    var recipes = [MockData.mockRecipe, MockData.mockRecipe]
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
    private let insets = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
    private var isShowingView = false
    
    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Food Recipes For You"
        recipesCollectionView.register(RecipeCollectionViewCell.nib, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShowingView = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isShowingView = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShowingView {
            recipesCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    //MARK: - IBActions
    @IBAction func didTapOnFilterButton(_ sender: Any) {
        
    }
    
    @IBAction func didTapOnSortingButton(_ sender: Any) {
        
    }
    
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let recipeCollectonViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier,
                                                                                for: indexPath)
                as? RecipeCollectionViewCell else { return RecipeCollectionViewCell() }
        
        let recipe = recipes[indexPath.row]
        
        recipeCollectonViewCell.setupCollectionViewCell(image: recipe.image,
                                                        title: recipe.title,
                                                        readyInMinutes: recipe.readyInMinutes)
        
        return recipeCollectonViewCell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = insets.left * (columns + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / columns
        return CGSize(width: widthPerItem, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets.left
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
