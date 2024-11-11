//
//  MockImageCacheManager.swift
//  RecipeTests
//
//  Created by Siran Li on 11/11/24.
//

import Foundation
@testable import Recipe
import SwiftUI

class MockImageCacheManager: ImageCacheManager {
    // Properties to simulate cache behavior
    var mockCache: [String: UIImage] = [:] // Dictionary to simulate an in-memory cache
    var shouldReturnImageFromCache = true // Flag to simulate cache hit/miss behavior
    var mockCacheSize: Int = 0 // Simulate the cache size
    
    // Load image from cache or return nil if not cached
    func loadImage(from url: String) async -> UIImage? {
        // Simulate a cache hit or miss
        if shouldReturnImageFromCache {
            return mockCache[url] // Return the cached image if available
        }
        
        return nil // Simulate a cache miss
    }
    
    // Cache an image for the given key
    func cacheImage(_ image: UIImage, for key: String) async {
        mockCache[key] = image // Simulate caching by adding the image to the mock cache
        mockCacheSize += imageDataSize(image) // Simulate cache size increment
    }
    
    // Clear the image cache (both in-memory and disk)
    func clearCache() {
        mockCache.removeAll() // Clear the cache
        mockCacheSize = 0 // Reset the cache size
    }
    
    // Retrieve an image from the cache based on a key
    func getCachedImage(forKey key: String) -> UIImage? {
        return mockCache[key] // Return the image from the mock cache if available
    }
    
    // Return the current disk cache size
    func getCacheSize() -> Int {
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

