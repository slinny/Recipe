//
//  RecipeListViewTests.swift
//  RecipeTests
//
//  Created by Siran Li on 11/14/24.
//

import XCTest
import SwiftUI
import ViewInspector
import SDWebImageSwiftUI
@testable import Recipe

final class RecipeListViewTests: XCTestCase {
    
    var viewModel: RecipeListViewModel!
    var inspectedView: InspectableView<ViewType.ClassifiedView>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Initialize the view model and set mock data
        viewModel = RecipeListViewModel()
        viewModel.recipes = MockRecipeDataProvider.mockRecipes
        
        // Wrap RecipeListView in AnyView to make it compatible with InspectableView's generic type
        let view = RecipeListView(viewModel: viewModel)
        inspectedView = try view.inspect()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        inspectedView = nil
        
        try super.tearDownWithError()
    }
    
    func testRecipesLoadedSuccessfully() throws {
        // Access the List and verify the number of items
        let list = try inspectedView.find(ViewType.List.self)
        
        let forEach = try list.find(ViewType.ForEach.self)
        XCTAssertEqual(forEach.count, 2) // Check that we have 2 items in the List
        
        // Access the first item and check its content
        let firstCell = try forEach[0].find(ViewType.HStack.self)  // Access first HStack
        XCTAssertEqual(try firstCell.vStack(1).text(0).string(), "Spaghetti") // Recipe name
        XCTAssertEqual(try firstCell.vStack(1).text(1).string(), "Italian")   // Cuisine type
        
        // Access the second item and check its content
        let secondCell = try forEach[1].find(ViewType.HStack.self)  // Access second HStack
        XCTAssertEqual(try secondCell.vStack(1).text(0).string(), "Sushi")    // Recipe name
        XCTAssertEqual(try secondCell.vStack(1).text(1).string(), "Japanese") // Cuisine type
    }
    
    func testErrorMessageDisplayed() throws {
        // Arrange: Mock ViewModel with an error
        viewModel.errorMessage = "Failed to load recipes."
        
        // Verify error message is displayed with correct color
        let errorText = try inspectedView.find(text: "Failed to load recipes.")
        XCTAssertEqual(try errorText.attributes().foregroundColor(), .red)
    }
    
    func testLoadingIndicatorIsShown() throws {
        // Arrange: Mock ViewModel with loading state
        viewModel.isLoading = true
        
        // Verify loading indicator is present
        XCTAssertNoThrow(try inspectedView.find(ViewType.ProgressView.self))
    }
}
