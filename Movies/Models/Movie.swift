//
//  Movie.swift
//  Movies
//
//  Created by Михаил Зиновьев on 27.11.2021.
//

import Foundation

struct Movie: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let type: String  //Type member must not be named 'Type', since it would conflict with the 'foo.Type' expression
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}

struct MovieSearch: Decodable {
    let Search: [Movie]
    let totalResults: String
    let Response: String
}
