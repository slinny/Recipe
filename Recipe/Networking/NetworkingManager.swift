//
//  NetworkingManager.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import Foundation

class URLSessionManager: NetworkSession {
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(from urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            // Handle network error
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            // Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Ensure data is not nil
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            // Success case
            completion(.success(data))
        }.resume()
    }
}
