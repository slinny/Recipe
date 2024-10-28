//
//  APIError.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case unknownError
}
