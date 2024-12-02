//
//  DataParserParserProtocol.swift
//  Recipe
//
//  Created by Siran Li on 11/10/24.
//

import Foundation

protocol DataParser {
    func parseData<T: Codable>(dataType type: T.Type, from data: Data) -> Result<T, APIError>
}
