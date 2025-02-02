//
//  RecipeTests.swift
//  RecipeTests
//
//  Created by Siran Li on 10/28/24.
//

import XCTest
@testable import Recipe

class URLSessionManagerTests: XCTestCase {
    
    var mockSession: MockRecipeURLSessionManager!
    
    override func setUp() {
        super.setUp()
        // Initialize the mock session before each test
        mockSession = MockRecipeURLSessionManager()
    }
    
    override func tearDown() {
        // Clean up any resources after each test
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() async throws {
        // Arrange
        mockSession.data = "Test Data".data(using: .utf8)
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        // Act
        let data = try await mockSession.fetchData(from: "https://example.com")
        
        // Assert
        XCTAssertEqual(data, "Test Data".data(using: .utf8))
    }
    
    func testFetchDataInvalidResponse() async {
        // Arrange
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                               statusCode: 404,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        // Act
        do {
            _ = try await mockSession.fetchData(from: "https://example.com")
            XCTFail("Expected to throw APIError.invalidResponse but no error was thrown")
        } catch {
            // Assert
            switch error as? APIError {
                case .invalidResponse:
                    XCTAssertTrue(true) // Expected error, pass the test
                default:
                    XCTFail("Expected APIError.invalidResponse, but got \(String(describing: error))")
            }
        }
    }
    
    func testFetchDataNetworkError() async {
        // Arrange
        let expectedURLError = URLError(.notConnectedToInternet)
        mockSession.error = expectedURLError
        
        // Act & Assert
        do {
            // Attempt to fetch data, expecting an error
            _ = try await mockSession.fetchData(from: "https://example.com")
            XCTFail("Expected network error, but the fetch succeeded.")
        } catch {
            // Assert: Check if the error is a network error and matches the expected error type
            if let urlError = error as? URLError {
                // If the error is URLError, it means we are dealing with a network error
                XCTAssertEqual(urlError, expectedURLError)
            } else if let apiError = error as? APIError {
                // If the error is an APIError (wrapped in networkError)
                switch apiError {
                    case .networkError(let urlError):
                        XCTAssertEqual(urlError as! URLError, expectedURLError)
                    default:
                        XCTFail("Expected network error for not connected to the internet, but got \(apiError).")
                }
            } else {
                XCTFail("Expected network error, but got \(error).")
            }
        }
    }
}
