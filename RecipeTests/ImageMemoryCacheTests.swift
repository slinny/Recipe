//
//  ImageMemoryCacheTests.swift
//  Recipe
//
//  Created by Siran Li on 11/18/24.
//

import XCTest
@testable import Recipe

class ImageMemoryCacheTests: XCTestCase {

    var mockImageMemoryCache: MockImageMemoryCache!

    override func setUp() {
        super.setUp()
        mockImageMemoryCache = MockImageMemoryCache()
    }

    override func tearDown() {
        mockImageMemoryCache = nil
        super.tearDown()
    }

    func testCacheImage() {
        // Given
        let image = UIImage(systemName: "star")! // Create a sample image
        let key = "testImageKey"

        // When
        mockImageMemoryCache.cache(image, forKey: key)

        // Then
        let cachedImage = mockImageMemoryCache.fetch(forKey: key)
        XCTAssertNotNil(cachedImage, "Image should be cached.")
        XCTAssertEqual(cachedImage, image, "The cached image should match the original image.")
        XCTAssertEqual(mockImageMemoryCache.cachedKeys, [key], "Cached key should be tracked.")
        XCTAssertEqual(mockImageMemoryCache.fetchedKeys, [key], "Fetched key should be tracked.")
    }

    func testFetchNonExistentImage() {
        // Given
        let key = "nonExistentImageKey"

        // When
        let cachedImage = mockImageMemoryCache.fetch(forKey: key)

        // Then
        XCTAssertNil(cachedImage, "Fetching a non-existent image should return nil.")
        XCTAssertEqual(mockImageMemoryCache.fetchedKeys, [key], "Fetched key should be tracked.")
    }

    func testCacheMultipleImages() {
        // Given
        let image1 = UIImage(systemName: "star")!
        let image2 = UIImage(systemName: "heart")!
        let key1 = "testImageKey1"
        let key2 = "testImageKey2"

        // When
        mockImageMemoryCache.cache(image1, forKey: key1)
        mockImageMemoryCache.cache(image2, forKey: key2)

        // Then
        let cachedImage1 = mockImageMemoryCache.fetch(forKey: key1)
        let cachedImage2 = mockImageMemoryCache.fetch(forKey: key2)
        XCTAssertNotNil(cachedImage1, "Image 1 should be cached.")
        XCTAssertNotNil(cachedImage2, "Image 2 should be cached.")
        XCTAssertEqual(cachedImage1, image1, "The cached image 1 should match the original image 1.")
        XCTAssertEqual(cachedImage2, image2, "The cached image 2 should match the original image 2.")
        XCTAssertEqual(mockImageMemoryCache.cachedKeys, [key1, key2], "Cached keys should be tracked.")
        XCTAssertEqual(mockImageMemoryCache.fetchedKeys, [key1, key2], "Fetched keys should be tracked.")
    }
}
