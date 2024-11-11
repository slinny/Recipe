//
//  MockRecipeImageCacheManager.swift
//  RecipeTests
//
//  Created by Siran Li on 11/10/24.
//

import Foundation
@testable import Recipe
import SwiftUI

// Mock RecipeImageCacheManager
class MockRecipeImageCacheManager: ImageCacheManager {
    // Properties for testing purposes
    var loadImageCalled = false
    var cacheImageCalled = false
    var clearCacheCalled = false
    var getCachedImageCalled = false
    var getCacheSizeCalled = false
    
    // Mock image to return for loadImage and getCachedImage
    var mockImage: UIImage?
    
    // Method to mock image caching
    func cacheImage(_ image: UIImage, for key: String) async {
        cacheImageCalled = true
        // You could add custom logic here, like storing the image in a dictionary for testing
    }
    
    // Method to mock clearing the cache
    func clearCache() {
        clearCacheCalled = true
        // Custom logic to simulate cache clearing if needed
    }
    
    // Method to mock retrieving an image from the cache
    func getCachedImage(forKey key: String) -> UIImage? {
        getCachedImageCalled = true
        return mockImage // Return the mock image for testing purposes
    }
    
    // Method to mock getting the cache size
    func getCacheSize() -> Int {
        getCacheSizeCalled = true
        return mockImage != nil ? 1 : 0 // For simplicity, return 1 if a mock image is set
    }
    
    // Method to mock loading an image from a URL
    func loadImage(from url: String) async -> UIImage? {
        loadImageCalled = true
        return mockImage // Return the mock image for testing purposes
    }
}


