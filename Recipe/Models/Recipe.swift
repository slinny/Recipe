//
//  Recipe.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import Foundation

// MARK: - RecipeResponse
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}
// MARK: - Recipe
struct Recipe: Codable, Identifiable {
    let id: String  // This is the Identifiable property
    let cuisine, name: String
    let photoURLLarge, photoURLSmall: String
    let sourceURL: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"  // Map 'id' to 'uuid' in the JSON response
        case cuisine, name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
