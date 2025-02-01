//
//  RecipeListViewModel.swift
//  Recipe
//
//  Created by Siran Li on 11/10/24.
//

import Foundation
import SwiftUI

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let urlSessionManager: NetworkSession
    private let dataDecoder: DataParser

    init(dependencies: AppDependencies) {
        self.urlSessionManager = dependencies.networkSession
        self.dataDecoder = DataDecoder()
    }
    
    @MainActor
    func loadRecipes() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            recipes = try await fetchRecipes()
        } catch {
            errorMessage = handleError(error)
        }
    }
    
    private func fetchRecipes() async throws -> [Recipe] {
        let data = try await fetchRecipeData()
        let recipeResponse = try parseRecipeData(data)
        return recipeResponse.recipes
    }
    
    private func fetchRecipeData() async throws -> Data {
        try await urlSessionManager.fetchData(from: URLConstants.urlString.rawValue)
    }
    
    private func parseRecipeData(_ data: Data) throws -> RecipeResponse {
        let result = dataDecoder.parseData(dataType: RecipeResponse.self, from: data)
        
        switch result {
            case .success(let recipeResponse):
                return recipeResponse
            case .failure(let error):
                throw APIError.decodingError(error)
        }
    }
    
    private func handleError(_ error: Error) -> String {
        // Map specific errors to user-friendly messages
        switch error {
            case APIError.invalidURL:
                return "Invalid URL provided."
            case APIError.networkError:
                return "Network error occurred. Please check your connection."
            case APIError.decodingError:
                return "Failed to decode the response. Please try again later."
            default:
                return "An unexpected error occurred."
        }
    }
}
