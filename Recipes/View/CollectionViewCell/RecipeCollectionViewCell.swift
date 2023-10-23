//
//  RecipeCollectionViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 19.10.23.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var readyInMinutesLabel: UILabel!
    static let identifier = "RecipeCollectionViewCell"
    static var nib: UINib {
        return UINib(nibName: "RecipeCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCollectionViewCell(image: String?, title: String?, readyInMinutes: Int?) {
        NetworkManager.shared.loadImage(imageString: image) { [weak self] image in
            self?.recipeImageView.image = image
        }
        recipeImageView.layer.cornerRadius = 10
        titleLabel.text = title
        readyInMinutesLabel.text?.append("\(readyInMinutes ?? 0)")
    }
    
    @IBAction func didClickOnLikeButton(sender: UIButton) {
        
    }
    
    override func prepareForReuse() {
        
    }

}
