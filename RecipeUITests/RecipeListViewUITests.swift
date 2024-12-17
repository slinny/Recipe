//
//  RecipeUITests.swift
//  RecipeUITests
//
//  Created by Siran Li on 12/1/24.
//

import XCTest

class RecipeListViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    func testRecipeListAppears() {
        // Verify that the recipe list appears
        let recipeList = app.tables.element(boundBy: 0)
        XCTAssertTrue(recipeList.exists)
    }

    func testRecipeListCellsLoadSuccessfully() {
        // Verify that recipe list cells appear
        let recipeListCells = app.tables["RecipeList"].cells
        XCTAssertTrue(recipeListCells.firstMatch.waitForExistence(timeout: 10), "Recipe List cells should exist.")
        XCTAssertGreaterThan(recipeListCells.count, 0, "Recipe List should contain at least one cell.")
    }

    func testRecipeListCellContentsDisplayCorrectly() {
        // Verify that recipe list cells contain the expected content
        let recipeListCell = app.tables["RecipeList"].cells.firstMatch
        XCTAssertTrue(recipeListCell.waitForExistence(timeout: 10), "The first Recipe List cell should exist.")
        
        let recipeNameLabel = recipeListCell.staticTexts["RecipeNameLabel"]
        let recipeCuisineLabel = recipeListCell.staticTexts["RecipeCuisineLabel"]
        XCTAssertTrue(recipeNameLabel.exists, "Recipe name label should exist in the cell.")
        XCTAssertTrue(recipeCuisineLabel.exists, "Recipe cuisine label should exist in the cell.")
    }

    func testRecipeListCellDisplaysImage() {
        // Verify that recipe list cells contain an image
        let recipeListCell = app.tables["RecipeList"].cells.firstMatch
        XCTAssertTrue(recipeListCell.waitForExistence(timeout: 10), "The first Recipe List cell should exist.")
        
        let recipeImage = recipeListCell.images["RecipeImageView"]
        XCTAssertTrue(recipeImage.exists, "Recipe image view should exist in the cell.")
    }

    func testPullToRefreshLoadsData() {
        // Verify that the pull-to-refresh control triggers a refresh
        let recipeList = app.tables["RecipeList"]
        XCTAssertTrue(recipeList.waitForExistence(timeout: 10), "The Recipe List should appear.")
        
        recipeList.swipeDown() // Trigger pull-to-refresh
        let refreshIndicator = app.activityIndicators["RefreshIndicator"]
        XCTAssertTrue(refreshIndicator.waitForExistence(timeout: 5), "Refresh indicator should appear.")
        XCTAssertTrue(refreshIndicator.waitForNonExistence(timeout: 10), "Refresh indicator should disappear after refresh.")
    }

    func testErrorMessageDisplaysOnError() {
        // Simulate an error condition (you may need to set up your app or mock for this)
        let errorMessageLabel = app.staticTexts["ErrorMessageLabel"]
        XCTAssertTrue(errorMessageLabel.waitForExistence(timeout: 10), "Error message label should appear.")
    }

    func testLoadingIndicatorDisplaysDuringDataLoad() {
        // Simulate a loading condition (you may need to set up your app or mock for this)
        let loadingIndicator = app.activityIndicators["LoadingIndicator"]
        XCTAssertTrue(loadingIndicator.waitForExistence(timeout: 10), "Loading indicator should appear during data load.")
    }
}

