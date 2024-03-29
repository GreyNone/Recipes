//
//  Recipe.swift
//  Recipes
//
//  Created by Александр Василевич on 19.10.23.
//

import UIKit

struct Recipes: Decodable {
    var recipes: [Recipe]?
    
    enum CodingKeys: String, CodingKey {
        case recipes
    }
}

struct SearchRecipes: Decodable {
    var recipes: [Recipe]?
    
    enum CodingKeys: String, CodingKey {
        case recipes = "results"
    }
}

struct Recipe: Decodable {
    var vegetarian: Bool?
    var vegan: Bool?
    var cheap: Bool?
    var veryHealthy: Bool?
    var veryPopular: Bool?
    var pricePerServing: Float?
    var cookingMinutes: Int?
    var aggregateLikes: Int?
    var healthScore: Int?
    var extendedIngredients: [Ingredient]?
    var id: Int?
    var title: String?
    var readyInMinutes: Int?
    var image: String?
    var summary: String?
    var instructions: String?
    var analyzedInstructions: [AnalyzedInstruction]?
    
    enum CodingKeys: String, CodingKey {
        case vegetarian
        case vegan
        case cheap
        case veryHealthy
        case veryPopular
        case pricePerServing
        case cookingMinutes
        case aggregateLikes
        case healthScore
        case extendedIngredients
        case id
        case title
        case readyInMinutes
        case image
        case summary
        case instructions
        case analyzedInstructions
    }
    
    var filterCases = [FilterCases]()
    var savedImage: UIImage?
}

extension Recipe {
    mutating func appendFilterCases() {
            if let isVegetarian = self.vegetarian, isVegetarian {
                self.filterCases.append(.vegetarian)
            }
            if let isVegan = self.vegan, isVegan {
                self.filterCases.append(.vegan)
            }
            if let isCheap = self.cheap, isCheap {
                self.filterCases.append(.cheap)
            }
            if let isVeryHealthy = self.veryHealthy, isVeryHealthy {
                self.filterCases.append(.veryHealthy)
            }
            if let isVeryPopular = self.veryPopular, isVeryPopular {
                self.filterCases.append(.veryPopular)
            }
        }
}
