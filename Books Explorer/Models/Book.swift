//
//  Book.swift
//  Books Explorer
//
//  Created by MR on 10/1/24.
//

import Foundation

struct Book: Decodable {
    let id: String
    let title: String
    let authorName: [String]?
    let firstPublishYear: Int?
    let coverId: Int?

    enum CodingKeys: String, CodingKey {
        case id = "key"
        case title
        case authorName = "author_name"
        case firstPublishYear = "first_publish_year"
        case coverId = "cover_i"
    }
}
