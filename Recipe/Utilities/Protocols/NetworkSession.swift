//
//  NetworkSession.swift
//  Recipe
//
//  Created by Siran Li on 10/25/24.
//

import Foundation

protocol NetworkSession {
    func fetchData(from urlString: String) async throws -> Data
}
