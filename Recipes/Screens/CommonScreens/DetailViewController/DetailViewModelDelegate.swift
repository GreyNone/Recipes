//
//  DetailViewModelDelegate.swift
//  Recipes
//
//  Created by Александр Василевич on 6.11.23.
//

import UIKit

protocol DetailViewModelDelegate: AnyObject {
    func reloadIngredientsCollectionView()
    func setImage(image: UIImage)
    func setTitle(text: String)
    func setPriceLabel(text: String)
    func setSummaryText(text: String)
    func setImageContainerViewAlpha(value: CGFloat)
    func setNavigationTitle(text: String?)
}
