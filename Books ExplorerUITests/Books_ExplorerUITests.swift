//
//  Books_ExplorerUITests.swift
//  Books ExplorerUITests
//
//  Created by MR on 10/1/24.
//

import XCTest

final class Books_ExplorerUITests: XCTestCase {
    let DEFAULT_TIME_OUT: Double = 5

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
        XCTAssertTrue(searchBar.waitForExistence(timeout: DEFAULT_TIME_OUT), "Search bar should exist") // Check for existence with timeout

        searchBar.tap()
        searchBar.typeText("Sample Book Title")
        
        sleep(1) //for timer works

        // Check if the table view appears and contains the expected book title
        let tableView = app.tables["BooksTableView"] // assuming you've set accessibility identifier for your table view
        XCTAssertTrue(tableView.waitForExistence(timeout: DEFAULT_TIME_OUT), "Table view should exist")
        
        let bookCell = tableView.cells.staticTexts["Sample book of children's titles"]
        XCTAssertTrue(bookCell.waitForExistence(timeout: DEFAULT_TIME_OUT), "Book cell should appear in the table view")
    }

    func testDetailViewPresentation() throws {
        // Launching the application
        let app = XCUIApplication()
        app.launch()
        
        // Perform search first
        let searchBar = app.searchFields["Search"]
        searchBar.tap()
        searchBar.typeText("Sample Book Title")
    
        sleep(1) //for timer works

        // Select the first book cell
        let tableView = app.tables["BooksTableView"]
        let bookCell = tableView.cells.staticTexts["Sample book of children's titles"]
        bookCell.tap()
        
        // Check if the detail view is presented
        let detailView = app.otherElements["DetailView"] // assuming you've set accessibility identifier for your detail view
        XCTAssertTrue(detailView.waitForExistence(timeout: DEFAULT_TIME_OUT), "Detail view should be presented")
        
        // Check if the detail contains the correct book title
        let detailTitle = detailView.staticTexts["BookTitleLabel"]
        XCTAssertTrue(detailTitle.exists, "Detail view should show the correct book title")
        
        XCTAssertEqual(detailTitle.label, "Sample book of children's titles", "Detail view should show the correct book title")
    }
}
