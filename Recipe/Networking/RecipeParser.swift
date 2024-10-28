//
//  RecipeParser.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import Foundation

class RecipeParser {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func parseRecipes(from data: Data) -> Result<[Recipe], APIError> {
        do {
            let recipes = try decoder.decode([Recipe].self, from: data)
            return .success(recipes)
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            return .failure(.decodingError(error))
        }
    }
}
