//
//  DataDecoderTests.swift
//  RecipeTests
//
//  Created by Siran Li on 11/10/24.
//

import XCTest
@testable import Recipe

class DataDecoderTests: XCTestCase {
    
    var decoder: DataDecoder!
    
    override func setUp() {
        super.setUp()
        // Initialize the DataDecoder instance before each test
        decoder = DataDecoder()
    }
    
    override func tearDown() {
        // Clean up the parser after each test
        decoder = nil
        super.tearDown()
    }
    
    // Test case for successful parsing of valid recipe JSON
    func testParseDataSuccess() {
        // Arrange: Use valid JSON data from MockRecipeDataProvider
        let data = MockRecipeDataProvider.validRecipeJSON
        
        // Act: Attempt to parse the data using DataDecoder
        let result = decoder.parseData(dataType: RecipeResponse.self, from: data)
        
        // Assert: Verify the result contains the correct recipe details
        switch result {
            case .success(let recipeResponse):
                // Assuming RecipeResponse has a property 'recipes' which holds an array of Recipe
                XCTAssertEqual(recipeResponse.recipes.count, 1, "Expected 1 recipe, but found \(recipeResponse.recipes.count).")
                let recipe = recipeResponse.recipes[0]
                XCTAssertEqual(recipe.cuisine, "Malaysian")
                XCTAssertEqual(recipe.name, "Apam Balik")
                XCTAssertEqual(recipe.photoURLLarge, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
                XCTAssertEqual(recipe.photoURLSmall, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
                XCTAssertEqual(recipe.sourceURL, "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
                XCTAssertEqual(recipe.id, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
                XCTAssertEqual(recipe.youtubeURL, "https://www.youtube.com/watch?v=6R8ffRRJcrg")
            case .failure:
                XCTFail("Expected successful parsing, but parsing failed.")
        }
    }
    
    // Test case for parsing failure when given invalid JSON data
    func testParseDataFailure_invalidJSON() {
        // Arrange: Use invalid JSON data from MockRecipeDataProvider
        let data = MockRecipeDataProvider.invalidRecipeJSON
        
        // Act: Attempt to parse the invalid JSON data using DataDecoder
        let result = decoder.parseData(dataType: RecipeResponse.self, from: data)
        
        // Assert: Ensure the result is a failure and verify the error
        switch result {
            case .success:
                XCTFail("Expected failure due to invalid JSON, but parsing succeeded.")
            case .failure(let error):
                // Assert: Verify the error is a decoding error
                if case APIError.decodingError(let underlyingError) = error {
                    XCTAssertTrue(underlyingError is DecodingError, "Expected DecodingError, but got \(underlyingError).")
                } else {
                    XCTFail("Expected decoding error, but got \(error).")
                }
        }
    }
}
