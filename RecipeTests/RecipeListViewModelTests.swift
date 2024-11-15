//
//  RecipeListViewModelTests.swift
//  RecipeTests
//
//  Created by Siran Li on 11/10/24.
//

import Foundation
@testable import Recipe
import XCTest
import SwiftUI

class RecipeListViewModelTests: XCTestCase {
    
    var viewModel: RecipeListViewModel!
    var mockParser: RecipeParser!
    var mockCacheManager: ImageCacheManager!
    var mockURLSessionManager: NetworkSession!
    
    override func setUp() {
        super.setUp()
        
        // Create mock instances for dependencies
        mockParser = MockRecipeDecoder()
        mockCacheManager = MockRecipeImageCacheManager()
        mockURLSessionManager = MockRecipeURLSessionManager()
        
        // Initialize the view model with mock dependencies
        viewModel = RecipeListViewModel(
            urlSessionManager: mockURLSessionManager,
            recipeParser: mockParser,
            imageCacheManager: mockCacheManager
        )
    }
    
    override func tearDown() {
        // Cleanup after each test
        viewModel = nil
        mockParser = nil
        mockCacheManager = nil
        mockURLSessionManager = nil
        super.tearDown()
    }
    
    func testLoadRecipes_Success() async throws {
        // Arrange
        let expectedRecipes = MockRecipeDataProvider.expectedRecipes
        
        // Configure mocks
        (mockURLSessionManager as! MockRecipeURLSessionManager).data = MockRecipeDataProvider.validRecipeJSON
        (mockParser as! MockRecipeDecoder).parseResult = .success(expectedRecipes)
        
        // Act
        await viewModel.loadRecipes()
        
        // Assert
        XCTAssertEqual(viewModel.recipes.count, expectedRecipes.recipes.count)
        XCTAssertEqual(viewModel.recipes.first?.name, expectedRecipes.recipes.first?.name)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadRecipes_Failure_DecodingError() async {
        // Arrange
        let decodingError = NSError(domain: "decoding", code: 1, userInfo: nil)
        
        (mockParser as! MockRecipeDecoder).parseResult = .failure(.decodingError(decodingError))
        (mockURLSessionManager as! MockRecipeURLSessionManager).data = Data() // Dummy data
        
        // Act
        await viewModel.loadRecipes()
        
        // Assert
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Failed to decode the response. Please try again later.")
    }
    
    func testLoadRecipes_Failure_NetworkError() async {
        // Arrange
        let networkError = NSError(domain: "network", code: 2, userInfo: nil)
        
        // Simulate a network error
        (mockURLSessionManager as! MockRecipeURLSessionManager).error = networkError
        (mockParser as! MockRecipeDecoder).parseResult = .success(MockRecipeDataProvider.expectedRecipes)
        
        // Act
        await viewModel.loadRecipes()
        
        // Assert
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Network error occurred. Please check your connection.")
    }
    
    func testLoadRecipes_Failure_UnknownError() async {
        // Arrange
        let unknownError = NSError(domain: "unknown", code: 3, userInfo: nil)
        
        // Simulate an unknown error
        (mockURLSessionManager as! MockRecipeURLSessionManager).error = unknownError
        (mockParser as! MockRecipeDecoder).parseResult = .failure(.unknownError)
        
        // Act
        await viewModel.loadRecipes()
        
        // Assert
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testImageCaching() async {
        // Arrange
        let expectedImage = UIImage(systemName: "star")! // Replace with a mock image
//        let mockCacheManager = MockImageCacheManager()
        
        // Simulate caching an image for a specific key
        let imageKey = "test_url"
        await mockCacheManager.cacheImage(expectedImage, for: imageKey)
        
        // Act
        let loadedImage = await mockCacheManager.loadImage(from: imageKey)
        
        // Assert
        XCTAssertNotNil(loadedImage, "Image should be loaded from the cache.")
        XCTAssertEqual(loadedImage, expectedImage, "The loaded image should match the expected image.")
    }
}
