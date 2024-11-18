//
//  NSCacheMemoryCache.swift
//  Recipe
//
//  Created by Siran Li on 11/17/24.
//
import Foundation
import SwiftUI

class ImageMemoryCache: MemoryCache {
    private let cache = NSCache<NSString, UIImage>()

    init() {
        cache.countLimit = 100 // Maximum number of cached images
        cache.totalCostLimit = 10 * 1024 * 1024 // Maximum cache size (10MB)
    }

    func cache(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func fetch(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
