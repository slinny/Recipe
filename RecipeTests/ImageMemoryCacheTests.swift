//
//  ImageMemoryCacheTests.swift
//  Recipe
//
//  Created by Siran Li on 11/18/24.
//

import XCTest
@testable import Recipe

class ImageMemoryCacheTests: XCTestCase {
    
    var imageCache: ImageMemoryCache!

    override func setUp() {
        super.setUp()
        imageCache = ImageMemoryCache()
    }

    override func tearDown() {
        imageCache = nil
        super.tearDown()
    }
    
    func testCacheImage() {
        // Given
        let image = UIImage(systemName: "star")! // Create a sample image
        let key = "testImageKey"
        
        // When
        imageCache.cache(image, forKey: key)
        
        // Then
        let cachedImage = imageCache.fetch(forKey: key)
        XCTAssertNotNil(cachedImage, "Image should be cached.")
        XCTAssertEqual(cachedImage, image, "The cached image should match the original image.")
    }

    func testFetchNonExistentImage() {
        // Given
        let key = "nonExistentImageKey"
        
        // When
        let cachedImage = imageCache.fetch(forKey: key)
        
        // Then
        XCTAssertNil(cachedImage, "Fetching a non-existent image should return nil.")
    }
}
