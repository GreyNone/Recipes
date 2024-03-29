//
//  RecipeCollectionViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 19.10.23.
//

import UIKit
import Moya

class RecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var readyInMinutesLabel: UILabel!
    static let identifier = "RecipeCollectionViewCell"
    static var nib: UINib {
        return UINib(nibName: "RecipeCollectionViewCell", bundle: nil)
    }
    var request: Cancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: (image: String?, savedImage: UIImage?, title: String?, readyInMinutes: Int?)) {
        if let savedImage = data.savedImage {
            self.recipeImageView.image = savedImage
        } else {
            request = NetworkManager.shared.loadImage(imageString: data.image) { [weak self] image in
                self?.recipeImageView.image = image
            }
        }
        
        recipeImageView.layer.cornerRadius = 10
        layer.add(TransitionAnimations.revealTransition(), forKey: nil)
        
        titleLabel.text = data.title
        readyInMinutesLabel.text? = "Ready in: \(data.readyInMinutes ?? 0) minutes"
    }
    
    override func prepareForReuse() {
        recipeImageView.image = nil
        request?.cancel()
    }

}
