//
//  Books_ExplorerUITests.swift
//  Books ExplorerUITests
//
//  Created by MR on 10/1/24.
//

import XCTest

final class Books_ExplorerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }

    func testSearchForBooks() throws {
        // Launching the application
        let app = XCUIApplication()
        app.launch()

        // Find the search bar and enter a search term
        let searchBar = app.searchFields["Search"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5), "Search bar should exist") // Check for existence with timeout

        searchBar.tap()
        searchBar.typeText("Sample Book Title")
        
        // Press return key
        app.keyboards.buttons["Return"].tap()

        // Check if the table view appears and contains the expected book title
        let tableView = app.tables["BooksTableView"] // assuming you've set accessibility identifier for your table view
        XCTAssertTrue(tableView.waitForExistence(timeout: 5), "Table view should exist")
        
        let bookCell = tableView.cells.staticTexts["Sample Book Title"]
        XCTAssertTrue(bookCell.waitForExistence(timeout: 5), "Book cell should appear in the table view")
    }

    func testDetailViewPresentation() throws {
        // Launching the application
        let app = XCUIApplication()
        app.launch()
        
        // Perform search first
        let searchBar = app.searchFields["Search"]
        searchBar.tap()
        searchBar.typeText("Sample Book Title")
        app.keyboards.buttons["Return"].tap()

        // Select the first book cell
        let tableView = app.tables["BooksTableView"]
        let bookCell = tableView.cells.staticTexts["Sample Book Title"]
        bookCell.tap()
        
        // Check if the detail view is presented
        let detailView = app.otherElements["DetailView"] // assuming you've set accessibility identifier for your detail view
        XCTAssertTrue(detailView.waitForExistence(timeout: 5), "Detail view should be presented")
        
        // Check if the detail contains the correct book title
        let detailTitle = detailView.staticTexts["Sample Book Title"]
        XCTAssertTrue(detailTitle.exists, "Detail view should show the correct book title")
    }
}
