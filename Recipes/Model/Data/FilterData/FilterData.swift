//
//  filterData.swift
//  Recipes
//
//  Created by Александр Василевич on 25.10.23.
//

import Foundation

enum FilterCases {
    case vegetarian
    case vegan
    case cheap
    case veryHealthy
    case veryPopular
}

struct Filter {
    var name: String
    var isChecked: Bool
    var filterCase: FilterCases
}

struct FilterData {
    static var vegetarian = Filter(name: "Vegetarian", isChecked: false, filterCase: .vegetarian)
    static var vegan = Filter(name: "Vegan", isChecked: false, filterCase: .vegan)
    static var cheap = Filter(name: "Cheap", isChecked: false, filterCase: .cheap)
    static var veryHealthy = Filter(name: "Healthy", isChecked: false, filterCase: .veryHealthy)
    static var veryPopular = Filter(name: "Popular", isChecked: false, filterCase: .veryPopular)
    
    static var allData = [vegetarian, vegan, cheap, veryHealthy, veryPopular]
}
