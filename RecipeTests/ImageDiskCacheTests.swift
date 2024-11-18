//
//  ImageDiskCacheTests.swift
//  Recipe
//
//  Created by Siran Li on 11/18/24.
//

import XCTest
import SwiftUI

@testable import Recipe

class ImageDiskCacheTests: XCTestCase {

    var imageCache: ImageDiskCache!
    var mockCacheDirectory: URL!
    
    override func setUp() {
        super.setUp()
        
        // Create a temporary directory for testing
        mockCacheDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        imageCache = ImageDiskCache(cacheDirectory: mockCacheDirectory)
    }
    
    override func tearDown() {
        // Clean up after each test
        try? FileManager.default.removeItem(at: mockCacheDirectory)
        super.tearDown()
    }
    
    func testStoreImageSuccessfully() throws {
        // Arrange
        let image = UIImage(systemName: "star.fill")!
        let key = "test_image"
        
        // Act
        try imageCache.store(image, forKey: key)
        
        // Assert
        let storedImage = try imageCache.retrieve(forKey: key)
        XCTAssertNotNil(storedImage)
    }

    func testRetrieveImageThatDoesNotExist() throws {
        // Act
        let retrievedImage = try imageCache.retrieve(forKey: "non_existent_key")
        
        // Assert
        XCTAssertNil(retrievedImage)
    }
    
    func testTotalCacheSize() throws {
        // Arrange
        let image1 = UIImage(systemName: "star.fill")!
        let image2 = UIImage(systemName: "heart.fill")!
        let key1 = "image1"
        let key2 = "image2"
        
        // Act
        try imageCache.store(image1, forKey: key1)
        try imageCache.store(image2, forKey: key2)
        
        // Assert
        let cacheSize = try imageCache.totalCacheSize()
        XCTAssertGreaterThan(cacheSize, 0)
    }
    
    func testEnforceStorageLimit() throws {
        // Arrange
        let smallImage = UIImage(systemName: "star.fill")!
        let largeImage = UIImage(systemName: "heart.fill")!
        let key1 = "smallImage"
        let key2 = "largeImage"
        
        // Get the data sizes for the images to ensure we understand the cache limit condition
        let smallImageData = smallImage.jpegData(compressionQuality: 1.0)!
        let largeImageData = largeImage.jpegData(compressionQuality: 1.0)!
        
        let smallImageSize = smallImageData.count
        let largeImageSize = largeImageData.count
        
        // Set a small storage limit for testing (e.g., 1 KB)
        let smallStorageLimit = 1024 // 1 KB
        
        let smallCache = ImageDiskCache(cacheDirectory: mockCacheDirectory, storageLimit: smallStorageLimit)
        
        // Act: Store both small and large images
        try smallCache.store(smallImage, forKey: key1)
        try smallCache.store(largeImage, forKey: key2)
        
        // Assert: Check if the storage limit is enforced and cache size is within the limit
        let cacheSize = try smallCache.totalCacheSize()
        XCTAssertLessThanOrEqual(cacheSize, smallStorageLimit)
        
        // Retrieve images
        let retrievedSmallImage = try smallCache.retrieve(forKey: key1)
        let retrievedLargeImage = try smallCache.retrieve(forKey: key2)
        
        // Assert that either both images are evicted (if both are too large) or one is evicted
        if smallImageSize + largeImageSize > smallStorageLimit {
            // If total size exceeds limit, both might be evicted, so neither should be retrievable
            XCTAssertNil(retrievedSmallImage)
            XCTAssertNil(retrievedLargeImage)
        } else {
            // If the total size is less than or equal to the limit, both should fit into the cache
            XCTAssertNotNil(retrievedSmallImage)
            XCTAssertNotNil(retrievedLargeImage)
        }
    }
    
    func testFailedToEncodeImage() {
        // Arrange
        let invalidImage = UIImage() // Invalid image, should fail to encode
        
        // Act & Assert
        XCTAssertThrowsError(try imageCache.store(invalidImage, forKey: "invalid_image")) { error in
            guard let cacheError = error as? ImageDiskCache.CacheError else {
                return XCTFail("Unexpected error type.")
            }
            XCTAssertEqual(cacheError, .failedToEncodeImage)
        }
    }
}
