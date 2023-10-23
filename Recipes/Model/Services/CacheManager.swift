//
//  CacheManager.swift
//  Recipes
//
//  Created by Александр Василевич on 20.10.23.
//

import Foundation
import UIKit

final class CacheManager {
    
    static let shared = CacheManager()
    private var imageCache = NSCache<AnyObject, AnyObject>()
    
    func saveImageToCache(image: UIImage, key: String) {
        imageCache.setObject(image, forKey: key as AnyObject)
    }
    
    func getImageFromCache(key: String) -> UIImage? {
        if let imageFromCache = imageCache.object(forKey: key as AnyObject) {
            let image = imageFromCache as? UIImage
            return image
        }
        return nil
    }
}
