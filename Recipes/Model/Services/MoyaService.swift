//
//  MoyaService.swift
//  Recipes
//
//  Created by Александр Василевич on 19.10.23.
//

import Foundation
import Moya

enum MoyaService {
    case recipes
    case image(String)
    case ingredientImage(String)
}

extension MoyaService: TargetType {
    var baseURL: URL {
        switch self {
        case .recipes:
            return URL(string: "https://api.spoonacular.com")!
        case .image(let image):
            return URL(string: image)!
        case .ingredientImage(_):
            return URL(string: "https://spoonacular.com/cdn/ingredients_100x100/")!
        }
    }
    var path: String {
        switch self {
        case .recipes:
            return "/recipes/random"
        case .image(_):
            return ""
        case .ingredientImage(let image):
            return image
        }
    }
    var headers: [String : String]? {
        return ["x-api-Key" : "4721d7561fee4b608074d80c55787119"]
    }
    var method: Moya.Method {
        switch self {
        case .recipes, .image(_), .ingredientImage(_):
            return .get
        }
    }
    var task: Task {
        switch self {
        case .recipes:
            return .requestParameters(parameters: ["number" : "10"], encoding: URLEncoding.default)
        case .image(_), .ingredientImage(_):
            return .requestPlain
        }
    }
    var sampleData: Data {
        return Data()
    }
}
