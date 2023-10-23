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
    var extendedIngridients: [Ingridient]?
    var id: Int?
    var title: String?
    var readyInMinutes: Int?
    var image: String?
    var summary: String?
    var instructions: String?
    var analyzedInstructions: AnalyzedInstruction?
    
    enum CodingKeys: String, CodingKey {
        case vegetarian
        case vegan
        case cheap
        case veryHealthy
        case veryPopular
        case pricePerServing
        case extendedIngridients
        case id
        case title
        case readyInMinutes
        case image
        case summary
        case instructions
        case analyzedInstructions
    }

}

struct Ingridient: Decodable {
    var id: Int?
    var name: String?
    var consistency: String?
    var amount: Float?
    var unit: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
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
