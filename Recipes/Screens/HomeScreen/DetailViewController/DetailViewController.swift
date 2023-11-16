//
//  DetailViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 25.10.23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var likeItemVIew: ItemView!
    @IBOutlet weak var timeItemView: ItemView!
    @IBOutlet weak var healthItemView: ItemView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var itemsContainerView: UIView!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var instructionsTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageViewContainerHeightConstraint: NSLayoutConstraint!
    var detailViewModel: DetailViewModel!
    
    static func makeDetailViewController(recipe: Recipe?) -> DetailViewController {
        let detailViewController = UIStoryboard(name: "DetailViewControllerStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.detailViewModel = DetailViewModel(recipe: recipe ?? MockData.mockRecipe)
        return detailViewController
    }
    
    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.instructionsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        self.title = nil
        navigationController?.view.layer.add(TransitionAnimations.onPopTransition(), forKey: nil)
        
        self.instructionsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                self.tableViewHeightConstraint.constant = newSize.height + 50.0
            }
        }
    }
    
    //MARK: - Custom Setup
    private func setup() {
        self.detailViewModel.delegate = self
        detailViewModel.setupUI()
        
        setupItemViews()
        addShadows(to: titleContainerView, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        addShadows(to: itemsContainerView, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        
        addLikeButtonToNavigationBar()
        
        ingredientsCollectionView.register(IngredientCollectionViewCell.nib, forCellWithReuseIdentifier: IngredientCollectionViewCell.identifier)
        configureHierarchy()
        
        instructionsTableView.register(InstructionTableViewCell.nib, forCellReuseIdentifier: InstructionTableViewCell.identifier)
        
    }
        
    private func addShadows(to view: UIView, corners: CACornerMask) {
        view.layer.cornerRadius = 7
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
        view.layer.maskedCorners = corners
    }
    
    private func setupItemViews() {
        likeItemVIew.configure(title: "\(detailViewModel.recipe.aggregateLikes ?? 0)",
                               image: UIImage(systemName: "hand.thumbsup")!,
                               tintColor: .systemYellow)
        timeItemView.configure(title: "\(detailViewModel.recipe.cookingMinutes ?? 30) min",
                               image: UIImage(systemName: "clock")!,
                               tintColor: .systemBlue)
        healthItemView.configure(title: "\(detailViewModel.recipe.healthScore ?? 20)",
                                 image: UIImage(systemName: "heart")!,
                                 tintColor: .systemRed)
    }
    
    private func addLikeButtonToNavigationBar() {
        let likeBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(likeButtonTapped))
        likeBarButtonItem.tintColor = UIColor(named: "mainColor")
        self.navigationItem.rightBarButtonItem = likeBarButtonItem
    }
    
    //MARK: - Actions
    @objc func likeButtonTapped() {
         
     }
    
    private func likeRecipe() {
        
    }
    
    private func dislikeRecipe() {
        
    }

}

//MARK: - DetailViewModelDelegate
extension DetailViewController: DetailViewModelDelegate {
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func setPriceLabel(text: String) {
        priceLabel.text = text
    }
    
    func setSummaryText(text: NSAttributedString) {
        summaryLabel.attributedText = text
    }

    func setImageContainerViewAlpha(value: CGFloat) {
        imageContainerView.alpha = value
    }
    
    func setNavigationTitle(text: String?) {
        self.title = text
    }
}

//MARK: - UICollectionViewDataSource
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

//MARK: - UICollectionViewCompositionalLayout
extension DetailViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let ingredientsCount = 3
            let contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(ingredientsCount)),
                                                                                 heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = contentInsets
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                    heightDimension: .fractionalHeight(1.0)),
                                                                 subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            return section
        }
        return layout
    }

    private func configureHierarchy() {
        ingredientsCollectionView.collectionViewLayout = createLayout()
    }
}

//MARK: - UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            detailViewModel.onScrollUpdate(contentOffsetY: scrollView.contentOffset.y,
                                           imageContainerViewHeight: imageViewContainerHeightConstraint.constant)
        }
    }
}

//MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        detailViewModel.numberOfSections ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        detailViewModel.numberOfItems(for: section) ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let instructionCell = tableView.dequeueReusableCell(withIdentifier: InstructionTableViewCell.identifier)
                as? InstructionTableViewCell else { return InstructionTableViewCell() }
        instructionCell.configure(data: detailViewModel.getStepInfo(for: indexPath))
        return instructionCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

}

//MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let instructionCell = tableView.cellForRow(at: indexPath) as? InstructionTableViewCell else { return }
        instructionCell.setExpandableView()
        
        UIView.animate(withDuration: 0.3) {
            tableView.performBatchUpdates(nil)
        }
//        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
