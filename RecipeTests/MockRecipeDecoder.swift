//
//  MockRecipeParser.swift
//  RecipeTests
//
//  Created by Siran Li on 11/10/24.
//

import Foundation
@testable import Recipe

// Mock RecipeParser
class MockRecipeDecoder: RecipeParser {
    var parseResult: Result<[Recipe], APIError>?
    
    func parseRecipes(from data: Data) -> Result<[Recipe], APIError> {
        return parseResult ?? .failure(.unknownError)
    }
}
