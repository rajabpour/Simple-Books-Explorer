//
//  APIService.swift
//  Books Explorer
//
//  Created by MR on 10/1/24.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}

    func searchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        let urlString = "https://openlibrary.org/search.json?title=\(query)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(response.books))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct SearchResponse: Decodable {
    let books: [Book]

    enum CodingKeys: String, CodingKey {
        case books = "docs"
    }
}
