//
//  CollectionViewTableViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 30.01.24.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    static var nib: UINib {
        return UINib(nibName: "CollectionViewTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCollectionView() {
        ingredientsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
        ingredientsCollectionView.register(AddNewCellCollectionViewCell.nib, forCellWithReuseIdentifier: AddNewCellCollectionViewCell.identifier)
        ingredientsCollectionView.register(AddIngredientCollectionViewCell.nib, forCellWithReuseIdentifier: AddIngredientCollectionViewCell.identifier)
        
        configureHierarchy()
    }
}

//MARK: - UICollectionViewLayout
extension CollectionViewTableViewCell {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let ingredientsCount = 2
            let contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(ingredientsCount)),
                                                                                 heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = contentInsets
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1),
                                                                                                    heightDimension: .fractionalHeight(1.0)),
                                                                 subitems: [item])
            group.contentInsets = contentInsets
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
        return layout
    }

    private func configureHierarchy() {
        ingredientsCollectionView.collectionViewLayout = createLayout()
    }
}

