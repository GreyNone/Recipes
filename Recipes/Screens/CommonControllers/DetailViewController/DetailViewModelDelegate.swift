//
//  DetailViewModelDelegate.swift
//  Recipes
//
//  Created by Александр Василевич on 6.11.23.
//

import UIKit

protocol DetailViewModelDelegate: AnyObject {
    func setImage(image: UIImage)
    func setTitle(text: String)
    func setPriceLabel(text: String)
    func setSummaryText(text: NSAttributedString)
    func setImageContainerViewAlpha(value: CGFloat)
    func setNavigationTitle(text: String?)
}
