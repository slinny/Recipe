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
    private let recipeParser: RecipeParser
    private let imageCacheManager: ImageCacheManager
    
    init(
        urlSessionManager: NetworkSession = RecipeURLSessionManager(),
        recipeParser: RecipeParser = RecipeDecoder(),
        imageCacheManager: ImageCacheManager = RecipeImageCacheManager.shared
    ) {
        self.urlSessionManager = urlSessionManager
        self.recipeParser = recipeParser
        self.imageCacheManager = imageCacheManager
    }
    
    func loadRecipes() async {
        do {
            self.recipes = try await fetchRecipes()
        } catch let apiError as APIError {
            self.errorMessage = handleError(apiError)
        } catch {
            self.errorMessage = handleError(.unknownError)
        }
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        self.isLoading = true
        self.errorMessage = nil
        
        defer { self.isLoading = false }
        
        do {
            let data = try await fetchRecipeData()
            let recipes = try parseRecipeData(data)
            await cacheImagesForRecipes(recipes)
            return recipes
        } catch let error as APIError {
            throw error // Throw specific APIError for testing
        } catch {
            throw APIError.unknownError // Catch-all error as APIError
        }
    }
    
    func fetchRecipeData() async throws -> Data {
        guard let url = URL(string: URLConstants.urlString.rawValue) else {
            throw APIError.invalidURL
        }
        
        do {
            return try await urlSessionManager.fetchData(from: url.absoluteString)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func parseRecipeData(_ data: Data) throws -> [Recipe] {
        let result = recipeParser.parseRecipes(from: data)
        
        switch result {
            case .success(let recipes):
                return recipes
            case .failure(let error):
                throw APIError.decodingError(error)
        }
    }
    
    private func cacheImagesForRecipes(_ recipes: [Recipe]) async {
        await withTaskGroup(of: Void.self) { group in
            for recipe in recipes {
                group.addTask {
                    async let largeImage = self.imageCacheManager.loadImage(from: recipe.photoURLLarge)
                    async let smallImage = self.imageCacheManager.loadImage(from: recipe.photoURLSmall)
                    _ = await largeImage
                    _ = await smallImage
                }
            }
        }
    }
    
    private func handleError(_ apiError: APIError) -> String {
        switch apiError {
            case .invalidURL:
                return "Invalid URL provided."
            case .networkError(_):
                return "Network error occurred."
            case .invalidResponse:
                return "Received an invalid response from the server."
            case .decodingError(_):
                return "Failed to decode data."
            case .unknownError:
                return "An unexpected error occurred."
        }
    }
}
