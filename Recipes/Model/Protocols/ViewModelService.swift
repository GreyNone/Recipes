//
//  ViewModelService.swift
//  Recipes
//
//  Created by Александр Василевич on 23.10.23.
//

import UIKit

enum ViewState {
    case idle
    case loading
    case success(UIImage?)
    case error
}

protocol RequestDelegate: AnyObject {
    func didUpdate(with state: ViewState)
}
