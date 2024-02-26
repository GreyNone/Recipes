//
//  TableViewCellDelegate.swift
//  Recipes
//
//  Created by Александр Василевич on 7.02.24.
//

import Foundation
import UIKit

protocol TableViewCellDelegate: AnyObject {
    func updateTableView()
    
    func presentZoomViewController(with image: UIImage)
    func presentController(controller: UIViewController)
    func dismissController()
    
    func removeItemFromCollectionView(item: AddIngredientCollectionViewCell)
    func removeItemFromTableView(item: UITableViewCell)
}

//extension TableViewCellDelegate {
//    func updateTableView() {
//        
//    }
//    
//    func setTableViewScroll() {
//        
//    }
//}
