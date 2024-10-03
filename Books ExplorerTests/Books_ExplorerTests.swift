//
//  Books_ExplorerTests.swift
//  Books ExplorerTests
//
//  Created by MR on 10/1/24.
//

import XCTest
@testable import Books_Explorer

final class Books_ExplorerTests: XCTestCase {

    func testBookModelDecoding() {
        let json = """
        {
            "key": "/works/OL12345W",
            "title": "Sample Book Title",
            "author_name": ["Author One", "Author Two"],
            "first_publish_year": 2000,
            "cover_i": 12345
        }
        """
        let jsonData = Data(json.utf8)
        do {
            let book = try JSONDecoder().decode(Book.self, from: jsonData)
            XCTAssertEqual(book.id, "/works/OL12345W")
            XCTAssertEqual(book.title, "Sample Book Title")
            XCTAssertEqual(book.authorName, ["Author One", "Author Two"])
            XCTAssertEqual(book.firstPublishYear, 2000)
            XCTAssertEqual(book.coverId, 12345)
        } catch {
            XCTFail("Failed to decode Book: \(error)")
        }
    }

    func testFetchBooksAPI() {
        let expectation = self.expectation(description: "Fetch Books from OpenLibrary API")
        
        APIService.shared.searchBooks(query: "Harry Potter") { result in
            switch result {
            case .success(let books):
                XCTAssertNotNil(books)
                XCTAssertGreaterThan(books.count, 0, "Expected at least one book")
            case .failure(let error):
                XCTFail("API call failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}

extension Books_ExplorerTests {
    
    func testTableViewDataSource() {
        let searchVC = SearchViewController()
        searchVC.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")

        searchVC.viewModel.addBooks(books: [
            Book(id: "/works/OL12345W", title: "Sample Book Title", authorName: ["Author One"], firstPublishYear: 2000, coverId: 12345),
            Book(id: "/works/OL67890W", title: "Another Book Title", authorName: ["Author Two"], firstPublishYear: 2005, coverId: 67890)
        ])
        
        searchVC.loadViewIfNeeded()
        
        let tableView = searchVC.tableView
        let numberOfRows = searchVC.tableView(tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, 2, "Number of rows in the table view should match the number of books.")
        
        let cell = searchVC.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel?.text, "Sample Book Title", "The cell's text should match the book title.")
    }
}
extension Books_ExplorerTests {
    
    func testSearchBooks() {
        let searchVC = SearchViewController()
        
        // Simulate user input
        searchVC.searchBar.text = "Sample Query"
        searchVC.searchBarSearchButtonClicked(searchVC.searchBar)
        
        let expectation = self.expectation(description: "Wait for search to complete")
        
        // Wait for the API request to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertGreaterThan(searchVC.viewModel.numberOfBooks(), 0, "Expected at least one book after search")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
