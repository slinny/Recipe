//
//  ImageDiskCacheTests.swift
//  Recipe
//
//  Created by Siran Li on 11/18/24.
//

import XCTest
@testable import Recipe

class ImageDiskCacheTests: XCTestCase {

    var mockImageDiskCache: MockImageDiskCache!

    override func setUp() {
        super.setUp()
        mockImageDiskCache = MockImageDiskCache()
    }

    override func tearDown() {
        mockImageDiskCache = nil
        super.tearDown()
    }

    func testStoreImageSuccessfully() throws {
        // Arrange
        let image = UIImage(systemName: "star.fill")!
        let key = "test_image"

        // Act
        try mockImageDiskCache.store(image, forKey: key)

        // Assert
        let storedImage = try mockImageDiskCache.retrieve(forKey: key)
        XCTAssertNotNil(storedImage)
    }

    func testRetrieveImageThatDoesNotExist() throws {
        // Act
        let retrievedImage = try mockImageDiskCache.retrieve(forKey: "non_existent_key")

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
        try mockImageDiskCache.store(image1, forKey: key1)
        try mockImageDiskCache.store(image2, forKey: key2)

        // Assert
        let cacheSize = try mockImageDiskCache.totalCacheSize()
        XCTAssertGreaterThan(cacheSize, 0)
    }
}
