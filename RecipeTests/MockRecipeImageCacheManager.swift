//
//  MockRecipeImageCacheManager.swift
//  RecipeTests
//
//  Created by Siran Li on 11/10/24.
//

import Foundation
@testable import Recipe
import SwiftUI

class MockRecipeImageCacheManager: ImageCacheManager {
    // Properties to simulate cache behavior
    var mockCache: [String: UIImage] = [:]
    var shouldReturnImageFromCache = true // Flag for cache hit/miss
    var mockCacheSize: Int = 0 // Simulated cache size
    var loadImageCalled = false
    var cacheImageCalled = false
    var clearCacheCalled = false
    var getCachedImageCalled = false
    var getCacheSizeCalled = false
    
    // Load image from cache or return nil if not cached
    func loadImage(from url: String) async -> UIImage? {
        loadImageCalled = true
        if shouldReturnImageFromCache {
            return mockCache[url] // Return the cached image if available
        }
        return nil // Simulate a cache miss
    }
    
    // Cache an image for the given key
    func cacheImage(_ image: UIImage, for key: String) async {
        cacheImageCalled = true
        mockCache[key] = image // Simulate caching by adding the image to the mock cache
        mockCacheSize += imageDataSize(image) // Simulate cache size increment
    }
    
    // Clear the image cache
    func clearCache() {
        clearCacheCalled = true
        mockCache.removeAll() // Clear the cache
        mockCacheSize = 0 // Reset the cache size
    }
    
    // Retrieve an image from the cache
    func getCachedImage(forKey key: String) -> UIImage? {
        getCachedImageCalled = true
        return mockCache[key] // Return the image from the mock cache if available
    }
    
    // Return the current cache size
    func getCacheSize() -> Int {
        getCacheSizeCalled = true
        return mockCacheSize // Return the simulated cache size
    }
    
    // Helper function to calculate the size of an image in bytes
    private func imageDataSize(_ image: UIImage) -> Int {
        guard let imageData = image.pngData() else {
            return 0
        }
        return imageData.count // Return the size in bytes of the image
    }
}
