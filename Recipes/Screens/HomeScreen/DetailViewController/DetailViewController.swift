//
//  DetailViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 25.10.23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var likeItemVIew: ItemView!
    @IBOutlet weak var timeItemView: ItemView!
    @IBOutlet weak var healthItemView: ItemView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var itemsContainerView: UIView!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var instructionsTableView: UITableView!
    var detailViewModel: DetailViewModel!
    
    static func makeDetailViewController(recipe: Recipe?) -> DetailViewController {
        let detailViewController = UIStoryboard(name: "DetailViewControllerStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.detailViewModel = DetailViewModel(recipe: recipe ?? MockData.mockRecipe)
        return detailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        self.title = detailViewModel.recipe.title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = nil
    }
    
    private func setup() {
        self.detailViewModel.delegate = self
        detailViewModel.setupUI()
        
        addShadows(to: titleContainerView)
        titleContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        addShadows(to: itemsContainerView)
        itemsContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        likeItemVIew.configure(title: "\(detailViewModel.recipe.aggregateLikes ?? 0)",
                               image: UIImage(systemName: "hand.thumbsup")!,
                               tintColor: .systemYellow)
        timeItemView.configure(title: "\(detailViewModel.recipe.cookingMinutes ?? 30)",
                               image: UIImage(systemName: "clock")!,
                               tintColor: .systemBlue)
        healthItemView.configure(title: "\(detailViewModel.recipe.healthScore ?? 20)",
                                 image: UIImage(systemName: "heart")!,
                                 tintColor: .systemRed)
        
        ingredientsCollectionView.register(IngredientCollectionViewCell.nib, forCellWithReuseIdentifier: IngredientCollectionViewCell.identifier)
    }
        
    private func addShadows(to view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }
}

extension DetailViewController: DetailViewModelDelegate {
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func setSummaryText(text: NSAttributedString) {
        summaryLabel.attributedText = text
    }
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfItems = detailViewModel?.numberOfItems else { return 1}
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let ingredientCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientCollectionViewCell.identifier,
                                                                                    for: indexPath)
                as? IngredientCollectionViewCell else { return IngredientCollectionViewCell() }
        
        ingredientCollectionViewCell.configure(data: detailViewModel.getInfo(for: indexPath))
        return ingredientCollectionViewCell
    }
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        detailViewModel.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return detailViewModel?.insets ?? UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return detailViewModel?.minimumLineSpacingForSection ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return detailViewModel?.minimumInteritemSpacingForSection ?? 10
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension DetailViewController: UITableViewDelegate {
    
}
