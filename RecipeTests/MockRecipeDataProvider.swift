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
    // Expected Recipe objects for assertion tests
    static var expectedRecipes: [Recipe] {
        return [
            Recipe(
                cuisine: "Malaysian",
                name: "Apam Balik",
                photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            )
        ]
    }
    
    // valid data
    static var validRecipeJSON: Data {
        let jsonString = """
        [
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
        """
        return jsonString.data(using: .utf8)!
    }
    
    // invalid data
    static var invalidRecipeJSON: Data {
        let jsonString = """
        [
            {
                "photo_url_large": "https://example.com/large.jpg",
                "photo_url_small": "https://example.com/small.jpg",
                "source_url": "https://example.com/recipe",
                "youtube_url": "https://youtube.com/video",
                "uuid": "12345"
            }
        ]
        
        """
        return jsonString.data(using: .utf8)!
    }
}

