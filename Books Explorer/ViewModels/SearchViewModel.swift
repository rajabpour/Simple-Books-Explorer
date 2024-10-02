//
//  SearchViewModel.swift
//  Books Explorer
//
//  Created by MR on 10/1/24.
//

import Foundation

class SearchViewModel {
    
    // MARK: - Properties
    var books: [Book] = []
    var onBooksUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    private(set) var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    // MARK: - Initializer
    init() {
    }
    
    // MARK: - Methods
    func searchBooks(query: String) {
        guard !query.isEmpty else {
            self.books = []
            self.onBooksUpdated?()
            return
        }
        
        self.isLoading = true
        APIService.shared.searchBooks(query: query) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let books):
                self.books = books
                self.onBooksUpdated?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func getBook(at index: Int) -> Book? {
        guard index >= 0 && index < books.count else {
            return nil
        }
        return books[index]
    }
    
    func numberOfBooks() -> Int {
        return books.count
    }
}
