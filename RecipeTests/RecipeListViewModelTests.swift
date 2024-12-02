//
//  MockNetworkSession.swift
//  Recipe
//
//  Created by Siran Li on 11/18/24.
//

import XCTest
@testable import Recipe

class RecipeListViewModelTests: XCTestCase {
    
    var viewModel: RecipeListViewModel!
    var mockURLSessionManager: MockRecipeURLSessionManager!
    var mockDataDecoder: MockDataDecoder<RecipeResponse>!
    
    override func setUp() {
        super.setUp()
        mockURLSessionManager = MockRecipeURLSessionManager()
        mockDataDecoder = MockDataDecoder()
        viewModel = RecipeListViewModel(
            urlSessionManager: mockURLSessionManager,
            dataDecoder: mockDataDecoder
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockURLSessionManager = nil
        mockDataDecoder = nil
        super.tearDown()
    }
    
    func testLoadRecipes_Success() async throws {
        // Arrange
        let expectedRecipes = MockRecipeDataProvider.expectedRecipes
        
        // Configure mocks
        (mockURLSessionManager!).data = MockRecipeDataProvider.validRecipeJSON
        (mockDataDecoder!).parseResult = .success(expectedRecipes)
        
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
        
        (mockDataDecoder!).parseResult = .failure(.decodingError(decodingError))
        (mockURLSessionManager!).data = Data() // Dummy data
        
        // Act
        await viewModel.loadRecipes()
        
        // Assert
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Failed to decode the response. Please try again later.")
    }
    
    func testLoadRecipes_Failure_NetworkError() async {
        // Arrange
        let customError = NSError(domain: "custom", code: 1, userInfo: ["description": "Custom error"])
        
        // Simulate a network error
        (mockURLSessionManager!).error = APIError.networkError(customError)
        (mockDataDecoder!).parseResult  = .success(MockRecipeDataProvider.expectedRecipes)
        
        // Act
        await viewModel.loadRecipes()
        
        // Assert
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Network error occurred. Please check your connection.")
    }
    
    func testLoadRecipesFailureWithInvalidResponse() async {
        // Simulate an invalid HTTP response
        mockURLSessionManager.response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        // Load the recipes
        await viewModel.loadRecipes()
        
        // Verify the view model's state after loading
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "An unexpected error occurred.")
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
    
    func testLoadRecipes_Failure_UnknownError() async {
        // Arrange
        let unknownError = NSError(domain: "unknown", code: 3, userInfo: nil)
        
        // Simulate an unknown error
        (mockURLSessionManager!).error = unknownError
        (mockDataDecoder!).parseResult = .failure(.unknownError)
        
        // Act
        await viewModel.loadRecipes()
        
        // Assert
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertFalse(viewModel.isLoading)
    }
}

