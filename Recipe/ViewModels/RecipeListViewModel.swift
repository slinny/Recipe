//
//  RecipeListViewModel.swift
//  Recipe
//
//  Created by Siran Li on 11/10/24.
//

import Foundation

class RecipeListViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let urlSessionManager: NetworkSession
    private let recipeDecoder: RecipeParser
    private let imageCacheManager: ImageCacheManager
    
    init(
        urlSessionManager: NetworkSession = RecipeURLSessionManager(),
        recipeParser: RecipeParser = RecipeDecoder(),
        imageCacheManager: ImageCacheManager = RecipeImageCacheManager.shared
    ) {
        self.urlSessionManager = urlSessionManager
        self.recipeDecoder = recipeParser
        self.imageCacheManager = imageCacheManager
    }
    
    @MainActor
    func loadRecipes() async {
        isLoading = true
        defer {
            // Ensure loading state is turned off when the function exits
            isLoading = false
        }
        
        do {
            // Fetch recipes asynchronously
            recipes = try await fetchRecipes()
        } catch {
            // Handle error gracefully
            errorMessage = handleError(error)
        }
    }
    
    private func fetchRecipes() async throws -> [Recipe] {
        let data = try await fetchRecipeData()
        let recipeResponse = try parseRecipeData(data)
        
        // Cache images asynchronously in the background
        await cacheImagesForRecipes(recipeResponse.recipes)
        
        return recipeResponse.recipes
    }
    
    private func fetchRecipeData() async throws -> Data {
        guard let url = URL(string: URLConstants.urlString.rawValue) else {
            throw APIError.invalidURL
        }
        do {
            return try await urlSessionManager.fetchData(from: url.absoluteString)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    private func parseRecipeData(_ data: Data) throws -> RecipeResponse {
        let result = recipeDecoder.parseRecipes(from: data)
        
        switch result {
            case .success(let recipeResponse):
                return recipeResponse
            case .failure(let error):
                throw APIError.decodingError(error)
        }
    }
    
    private func cacheImagesForRecipes(_ recipes: [Recipe]) async {
        await withTaskGroup(of: Void.self) { group in
            for recipe in recipes {
                group.addTask {
                    // Async image loading for each recipe
                    async let largeImage = self.imageCacheManager.loadImage(from: recipe.photoURLLarge)
                    async let smallImage = self.imageCacheManager.loadImage(from: recipe.photoURLSmall)
                    
                    _ = await largeImage
                    _ = await smallImage
                }
            }
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
