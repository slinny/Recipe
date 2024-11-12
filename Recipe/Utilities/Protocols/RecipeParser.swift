//
//  RecipeParserProtocol.swift
//  Recipe
//
//  Created by Siran Li on 11/10/24.
//

import Foundation

protocol RecipeParser {
    func parseRecipes(from data: Data) -> Result<RecipeResponse, APIError>
}
