//
//  MockDataProvider.swift
//  RecipeTests
//
//  Created by Siran Li on 11/10/24.
//

import Foundation
@testable import Recipe

// Mock class to provide test data
class MockRecipeDataProvider {
    
    // Expected RecipeResponse for assertion in tests
    static var expectedRecipes: RecipeResponse {
        RecipeResponse(recipes: [
            Recipe(
                id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                cuisine: "Malaysian",
                name: "Apam Balik",
                photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            )
        ])
    }
    
    // Valid JSON data for a successful parse
    static var validRecipeJSON: Data {
        let jsonString = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                }
            ]
        }
        """
        return jsonString.data(using: .utf8)!
    }
    
    // Invalid JSON data missing required fields for a failure case
    static var invalidRecipeJSON: Data {
        let jsonString = """
        {
            "recipes": [
                {
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg",
                    "source_url": "https://example.com/recipe",
                    "youtube_url": "https://youtube.com/video",
                    "uuid": "12345"
                }
            ]
        }
        """
        return jsonString.data(using: .utf8)!
    }
    
    // Mock Recipe List to return as the viewModel data
    static var mockRecipes: [Recipe] {
        return [
            Recipe(id: "1", cuisine: "Italian", name: "Spaghetti",
                   photoURLLarge: "https://example.com/spaghetti_large.jpg",
                   photoURLSmall: "https://example.com/spaghetti_small.jpg",
                   sourceURL: "https://example.com/spaghetti_recipe",
                   youtubeURL: "https://youtube.com/spaghetti_video"),
            Recipe(id: "2", cuisine: "Japanese", name: "Sushi",
                   photoURLLarge: "https://example.com/sushi_large.jpg",
                   photoURLSmall: "https://example.com/sushi_small.jpg",
                   sourceURL: "https://example.com/sushi_recipe",
                   youtubeURL: "https://youtube.com/sushi_video")
        ]
    }
}
