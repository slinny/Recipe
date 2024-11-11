//
//  NetworkingManager.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import Foundation

class RecipeURLSessionManager: NetworkSession {
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(for: URLRequest(url: url))
            
            // Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            return data
        } catch {
            // Handle network error
            if let urlError = error as? URLError {
                throw APIError.networkError(urlError)
            }
            throw APIError.unknownError
        }
    }
}
