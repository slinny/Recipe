//
//  MockDataDecoder.swift
//  RecipeTests
//
//  Created by Siran Li on 11/10/24.
//

import Foundation
@testable import Recipe

// Mock DataDecoder
class MockDataDecoder<T: Codable>: DataParser {
    
    var parseResult: Result<T, APIError>?
    
    func parseData<U: Codable>(dataType type: U.Type, from data: Data) -> Result<U, APIError> {
        guard U.self == T.self else {
            return .failure(.unknownError)
        }
        
        return parseResult as? Result<U, APIError> ?? .failure(.unknownError)
    }
}
