//
//  RecipeImplementation.swift
//  Recipes
//
//  Created by Александр Василевич on 14.11.23.
//

import UIKit

struct Ingredient: Decodable {
    var id: Int?
    var name: String?
    var image: String?
    var consistency: String?
    var amount: Float?
    var unit: String?
    
    var savedImage: UIImage?
    
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
    var name: String?
    var steps: [Step]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case steps
    }
}

struct Step: Decodable, Equatable {
    var number: Int?
    var step: String?
    
    enum CodingKeys: String, CodingKey {
        case number
        case step
    }
}
