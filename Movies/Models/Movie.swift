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
    let type: String
    let poster: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
    init(title: String, year: String, imdbID: String, type: String, poster: String?) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.type = type
        self.poster = poster
    }
    
    init(movieData: [String: Any]) {
        title = movieData["Title"] as? String ?? ""
        year = movieData["Year"] as? String ?? ""
        imdbID = movieData["imdbID"] as? String ?? ""
        type = movieData["Type"] as? String ?? ""
        poster = movieData["Poster"] as? String ?? ""
    }
}

struct MovieSearch: Decodable {
    let search: [Movie]
    let totalResults: String
    let response: String
    
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
    
    init(search: [Movie], totalResults: String, response: String) {
        self.search = search
        self.totalResults = totalResults
        self.response = response
    }
    
    init(movieSearch: [String: Any]) {
        search = MovieSearch.getMovies(from: movieSearch["Search"] ?? [])
        totalResults = movieSearch["totalResults"] as? String ?? ""
        response = movieSearch["Response"] as? String ?? ""
    }
    
    static func getMovieSearch(from value: Any) -> MovieSearch {
        guard let movieSearchData = value as? [String: Any] else {
            return MovieSearch(search: [], totalResults: "0", response: "0")
        }
        
        return MovieSearch(movieSearch: movieSearchData)
    }
    
    static func getMovies(from value: Any) -> [Movie] {
        guard let moviesData = value as? [[String: Any]] else { return [] }
        return moviesData.compactMap { Movie(movieData: $0) }
    }
}
