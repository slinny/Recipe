//
//  DataDecoder.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import Foundation

class DataDecoder: DataParser {
    
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func parseData<T: Codable>(dataType type: T.Type, from data: Data) -> Result<T, APIError> {
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            return .failure(.decodingError(error))
        }
    }
}
