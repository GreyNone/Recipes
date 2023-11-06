//
//  Recipe.swift
//  Recipes
//
//  Created by Александр Василевич on 19.10.23.
//

import Foundation

struct Recipes: Decodable {
    var recipes: [Recipe]?
    
    enum CodingKeys: String, CodingKey {
        case recipes
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
    var filterCases = [FilterCases]()
    
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

struct Ingredient: Decodable {
    var id: Int?
    var name: String?
    var image: String?
    var consistency: String?
    var amount: Float?
    var unit: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case consistency
        case amount
        case unit
    }
}

struct AnalyzedInstruction: Decodable {
    var steps: [Step]?
    
    enum CodingKeys: String, CodingKey {
        case steps
    }
}

struct Step: Decodable {
    var number: Int?
    var step: String?
    var length: Length?
    
    enum CodingKeys: String, CodingKey {
        case number
        case step
        case length
    }
}

struct Length: Decodable {
    var number: Int?
    var unit: String?
    
    enum CodingKeys: String, CodingKey {
        case number
        case unit
    }
}
