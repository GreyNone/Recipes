//
//  FilterViewModel.swift
//  Recipes
//
//  Created by Александр Василевич on 26.10.23.
//

import Foundation

final class FilterViewModel {
    
}

extension FilterViewModel {
    var numberOfItems: Int {
        FilterData.allData.count
    }
    
    func getInfo(for indexPath: IndexPath) -> (name: String, isChecked: Bool) {
        let filter = FilterData.allData[indexPath.row]
        return (filter.name, filter.isChecked)
    }
    
    func isCheckedState(for indexPath: IndexPath) -> Bool {
        return FilterData.allData[indexPath.row].isChecked
    }
    
    func isCheckUpdate(for indexPath: IndexPath) {
        FilterData.allData[indexPath.row].isChecked = !isCheckedState(for: indexPath)
    }
}
