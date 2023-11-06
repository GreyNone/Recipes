//
//  HomeViewModelDelegate.swift
//  Recipes
//
//  Created by Александр Василевич on 6.11.23.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func updateCollectionView()
    func startActivityIndicator()
    func stopActivityIndicator()
    func presentEmptyStatusView()
    func dismissEmptyStatusView()
}
