//
//  IngredientCollectionViewCell.swift
//  Recipes
//
//  Created by Александр Василевич on 1.11.23.
//

import UIKit
import Moya

class IngredientCollectionViewCell: UICollectionViewCell {

    static let identifier = "IngredientCollectionViewCell"
    static var nib: UINib {
        return UINib(nibName: "IngredientCollectionViewCell", bundle: nil)
    }
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var request: Cancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerStackView.layer.cornerRadius = 10
        containerStackView.layer.borderWidth = 0.5
        containerStackView.layer.borderColor = UIColor.black.cgColor
    }
    
    func configure(data: (title: String?, image: String?, unit: String?, amount: Float?)) {
        request = NetworkManager.shared.loadIngredientImage(imageString: data.image) { [weak self] image in
            self?.imageView.image = image
        }
        titleLabel.text = data.title
        unitLabel.text = "\(data.amount ?? 10.0) " + (data.unit ?? "g")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        request?.cancel()
    }
}
