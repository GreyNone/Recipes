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
    
    //MARK: - Controller lifecycle
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
        
        addShadows(to: titleContainerView, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        addShadows(to: itemsContainerView, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        
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
        configureHierarchy()
        
        instructionsTableView.register(InstructionTableViewCell.nib, forCellReuseIdentifier: InstructionTableViewCell.identifier)
        instructionsTableView.register(StepTableViewCell.nib, forCellReuseIdentifier: StepTableViewCell.identifier)
        instructionsTableView.rowHeight = UITableView.automaticDimension
        instructionsTableView.estimatedRowHeight = 100
    }
        
    private func addShadows(to view: UIView, corners: CACornerMask) {
        view.layer.cornerRadius = 7
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
        view.layer.maskedCorners = corners
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
    
    func setSummaryText(text: NSAttributedString) {
        summaryLabel.attributedText = text
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
            
            let contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                        
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
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

//MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        detailViewModel.numberOfSections ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        detailViewModel.numberOfItems(for: section) ?? 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        detailViewModel.title(for: section) ?? "Instruction"
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath != detailViewModel.selectedIndexPath {
//            return 100
//        }
//        return .zero
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let selectedIndexPath = detailViewModel.selectedIndexPath,
           indexPath == IndexPath(row: selectedIndexPath.row + 1,
                                  section: selectedIndexPath.section) {
            guard let stepCell = tableView.dequeueReusableCell(withIdentifier: StepTableViewCell.identifier)
                    as? StepTableViewCell else { return StepTableViewCell() }
            stepCell.configure(data: detailViewModel.getStepInfo(for: indexPath))
            return stepCell
        }
        
        guard let instructionCell = tableView.dequeueReusableCell(withIdentifier: InstructionTableViewCell.identifier)
                as? InstructionTableViewCell else { return InstructionTableViewCell() }
        instructionCell.titleLabel.text = detailViewModel.getStepNumber(for: indexPath)
        return instructionCell
    }
}

//MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedIndexPath = detailViewModel.selectedIndexPath, selectedIndexPath == indexPath {
            detailViewModel.selectedIndexPath = nil
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .fade)
            tableView.endUpdates()
            return
        }
        
        // Collapse the previously expanded cell
        if let selectedIndexPath = detailViewModel.selectedIndexPath {
            detailViewModel.selectedIndexPath = nil
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: selectedIndexPath.row + 1, section: selectedIndexPath.section)], with: .fade)
            tableView.endUpdates()
            return
        }
        
        detailViewModel.selectedIndexPath = indexPath
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .fade)
        tableView.endUpdates()
    }
}
