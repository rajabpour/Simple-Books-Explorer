//
//  BookDetailViewModel.swift
//  Books Explorer
//
//  Created by MR on 10/1/24.
//

import Foundation

class BookDetailViewModel {
    
    // MARK: - Properties
    private let book: Book
    
    var title: String {
        return book.title
    }
    
    var authors: String {
        return book.authorName?.joined(separator: ", ") ?? ""
    }
    
    var firstPublishedYear: String {
        if let year = book.firstPublishYear {
            return "\(year)"
        } else {
            return "Unknown"
        }
    }
    
    var coverURL: URL? {
        guard let coverId = book.coverId else {
            return nil
        }
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg")
    }
    
    // MARK: - Initializer
    init(book: Book) {
        self.book = book
    }
}
