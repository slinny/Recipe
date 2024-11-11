//
//  RecipeImageCacheManagerTests.swift
//  RecipeTests
//
//  Created by Siran Li on 11/10/24.
//

import Foundation
@testable import Recipe
import XCTest
import SDWebImage

final class RecipeImageCacheManagerTests: XCTestCase {
    
    var imageCacheManager: RecipeImageCacheManager!
    
    override func setUp() {
        super.setUp()
        imageCacheManager = RecipeImageCacheManager.shared
        imageCacheManager.clearCache()
    }
    
    override func tearDown() {
        imageCacheManager.clearCache()
        imageCacheManager = nil
        super.tearDown()
    }
    
    func testLoadImageFromCache() async {
        // Arrange
        let cacheKey = "cached-image"
        let image = UIImage(systemName: "star")!
        await imageCacheManager.cacheImage(image, for: cacheKey) // Manually cache an image
        
        // Act
        let cachedImage = await imageCacheManager.loadImage(from: cacheKey)
        
        // Assert
        XCTAssertNotNil(cachedImage, "The image should be returned from the cache")
    }
    
    func testLoadImageFromNetwork() async {
        // Arrange
        let validURLString = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
        
        // Act
        let downloadedImage = await imageCacheManager.loadImage(from: validURLString)
        
        // Assert
        XCTAssertNotNil(downloadedImage, "The image should be downloaded and returned when not cached")
        
        // Ensure the image is cached after download
        let cachedImage = imageCacheManager.getCachedImage(forKey: validURLString)
        XCTAssertNotNil(cachedImage, "The image should be cached after it is downloaded")
    }
    
    func testLoadImageWithInvalidURL() async {
        // Arrange
        let invalidURLString = "invalid-url"
        
        // Act
        let result = await imageCacheManager.loadImage(from: invalidURLString)
        
        // Assert
        XCTAssertNil(result, "The image should return nil if the URL is invalid")
    }
    
    func testCacheImageSuccessfully() async {
        // Arrange
        let image = UIImage(systemName: "star")!
        let cacheKey = "star"
        
        // Act
        await imageCacheManager.cacheImage(image, for: cacheKey)
        
        // Assert
        let cachedImage = imageCacheManager.getCachedImage(forKey: cacheKey)
        XCTAssertNotNil(cachedImage, "Image should be cached successfully")
    }
    
    func testClearCacheSuccessfully() async {
        // Arrange
        let image = UIImage(systemName: "star")!
        let cacheKey = "star"
        await imageCacheManager.cacheImage(image, for: cacheKey)
        
        // Act
        imageCacheManager.clearCache()
        
        // Assert
        let cachedImage = imageCacheManager.getCachedImage(forKey: cacheKey)
        XCTAssertNil(cachedImage, "Cache should be cleared successfully, so no image should be found.")
    }
    
    func testGetCachedImage() async {
        // Arrange
        let image = UIImage(systemName: "star")!
        let cacheKey = "test-star-image"
        
        // Act
        await imageCacheManager.cacheImage(image, for: cacheKey)
        
        // Assert
        let cachedImage = imageCacheManager.getCachedImage(forKey: cacheKey)
        XCTAssertNotNil(cachedImage, "Cached image should be retrievable by key")
    }
    
    func testGetCacheSize() async {
        // Arrange
        let initialCacheSize = imageCacheManager.getCacheSize()
        let image = UIImage(systemName: "star")!
        let cacheKey = "test-star-image"
        
        // Act
        await imageCacheManager.cacheImage(image, for: cacheKey)
        
        // Assert
        let updatedCacheSize = imageCacheManager.getCacheSize()
        XCTAssertGreaterThan(updatedCacheSize, initialCacheSize, "Cache size should increase after adding an image")
    }
}

