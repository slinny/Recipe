//
//  MockImageMemoryCache.swift
//  Recipe
//
//  Created by Siran Li on 2/1/25.
//

import SwiftUI
@testable import Recipe

class MockImageMemoryCache: MemoryCache {
    var cachedImages: [String: UIImage] = [:]
    var fetchedKeys: [String] = []
    var cachedKeys: [String] = []

    func cache(_ image: UIImage, forKey key: String) {
        cachedImages[key] = image
        cachedKeys.append(key)
    }

    func fetch(forKey key: String) -> UIImage? {
        fetchedKeys.append(key)
        return cachedImages[key]
    }
}
