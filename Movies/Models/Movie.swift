//
//  Movie.swift
//  Movies
//
//  Created by Михаил Зиновьев on 27.11.2021.
//

import Foundation

struct Movie: Decodable {
    let Title: String
    let Year: String
    let imdbID: String
    let `Type`: String  //Type member must not be named 'Type', since it would conflict with the 'foo.Type' expression
    let Poster: String
}

struct MovieSearch: Decodable {
    let Search: [Movie]
    let totalResults: String
    let Response: String
}
