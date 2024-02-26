//
//  NewRecipeViewModelDelegate.swift
//  Recipes
//
//  Created by Александр Василевич on 31.01.24.
//

import Foundation

protocol NewRecipeViewModelDelegate: AnyObject {
    func insertNewElementInCollectionView(at indexPath: IndexPath)
    func insertNewElementInTableView(at indexPath: IndexPath)
    func removeElementFromCollectionView(at indexPath: IndexPath)
    func removeElementFromTableView(at indexPath: IndexPath)
    func updateCellTitles(at indexPaths: [IndexPath])
}
