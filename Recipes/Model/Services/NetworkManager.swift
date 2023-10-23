//
//  NetworkManager.swift
//  Recipes
//
//  Created by Александр Василевич on 19.10.23.
//

import UIKit
import Moya

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let moyaProvider = MoyaProvider<MoyaService>()
    
    func loadRecipes(completion: @escaping ([Recipe]?) -> Void) {
        moyaProvider.request(.recipes) { result in
            switch result {
            case .success(let response):
                let fetchedRecipes = try? response.map(Recipes.self)
                completion(fetchedRecipes?.recipes)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadImage(imageString: String?, completion: @escaping (UIImage?) -> Void) -> Cancellable? {
        guard let imageString = imageString,
              !imageString.isEmpty else {
            let mockImage = UIImage(named: "mockImage")
            if let mockImage = mockImage {
                completion(mockImage)
            }
            return nil
        }
        
        if let image = CacheManager.shared.getImageFromCache(key: imageString) {
            completion(image)
            return nil
        }
        
        let imageRequest = moyaProvider.request(.image(imageString)) { result in
            switch result {
            case .success(let response):
                var image: UIImage?
                
                defer {
                    DispatchQueue.main.async {
                        if let image = image {
                            CacheManager.shared.saveImageToCache(image: image, key: imageString)
                        }
                        completion(image)
                        return
                    }
                }
                
                image = UIImage(data: response.data)
            case .failure(_):
                let mockImage = UIImage(systemName: "mockData")
                if let mockImage = mockImage {
                    completion(mockImage)
                }
            }
        }
    }
}
