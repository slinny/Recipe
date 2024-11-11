//
//  MockURLSession.swift
//  RecipeTests
//
//  Created by Siran Li on 10/28/24.
//

import Foundation
@testable import Recipe

class MockRecipeURLSessionManager: NetworkSession {
    // Properties to simulate different scenarios
    var data: Data?
    var error: Error?
    var response: URLResponse?
    
    func fetchData(from urlString: String) async throws -> Data {
        // If an error is set, throw it to simulate a network error
        if let error = error {
            throw error
        }
        
        // Check if response is a valid HTTPURLResponse with a success status code
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw APIError.invalidResponse
        }
        
        // Return the mock data if available
        if let data = data {
            return data
        }
        
        // If none of the above, throw an unknown error
        throw APIError.unknownError
    }
}
