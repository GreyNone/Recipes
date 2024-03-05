//
//  HomeViewModelDelegate.swift
//  Recipes
//
//  Created by Александр Василевич on 6.11.23.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func reloadCollectionView()
    func insertNewElementInCollectionView(at indexPath: IndexPath)
    func startActivityIndicator()
    func stopActivityIndicator()
    func presentEmptyStatusView()
    func dismissEmptyStatusView()
}
