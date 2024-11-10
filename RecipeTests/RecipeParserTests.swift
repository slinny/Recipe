//
//  RecipeParserTests.swift
//  RecipeTests
//
//  Created by Siran Li on 11/10/24.
//

import XCTest
@testable import Recipe

class RecipeParserTests: XCTestCase {
    
    var parser: RecipeParser!
    
    override func setUp() {
        super.setUp()
        // Initialize the real parser
        parser = RecipeParser()
    }
    
    override func tearDown() {
        // Clean up the resources
        parser = nil
        super.tearDown()
    }

    func testParseRecipesSuccess() {
        // Arrange: Use valid JSON data from MockDataProvider
        let data = MockDataProvider.validRecipeJSON
        
        // Act: Parse the data using the real parser
        let result = parser.parseRecipes(from: data)
        
        // Assert: Check if the result is success and contains the correct recipe details
        switch result {
        case .success(let recipes):
            XCTAssertEqual(recipes.count, 1)
            XCTAssertEqual(recipes[0].cuisine, "Malaysian")
            XCTAssertEqual(recipes[0].name, "Apam Balik")
            XCTAssertEqual(recipes[0].photoURLLarge, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
            XCTAssertEqual(recipes[0].photoURLSmall, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
            XCTAssertEqual(recipes[0].sourceURL, "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
            XCTAssertEqual(recipes[0].uuid, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
            XCTAssertEqual(recipes[0].youtubeURL, "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        case .failure:
            XCTFail("Expected successful parsing but got failure.")
        }
    }

    func testParseRecipesFailure_invalidJSON() {
        // Arrange: Use invalid JSON data from MockDataProvider
        let data = MockDataProvider.invalidRecipeJSON
        
        // Act: Parse the data using the real parser
        let result = parser.parseRecipes(from: data)
        
        // Assert: Check if the result is failure and contains the expected error
        switch result {
        case .success:
            XCTFail("Expected failure due to missing 'youtube_url' key, but got success.")
        case .failure(let error):
            // Assert: Ensure the error is a decoding error with the expected underlying error
            if case APIError.decodingError(let underlyingError) = error {
                XCTAssertTrue(underlyingError is DecodingError, "Expected DecodingError but got \(underlyingError).")
            } else {
                XCTFail("Expected decodingError, but got \(error).")
            }
        }
    }
}




