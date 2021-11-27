//
//  MovieListManager.swift
//  Movies
//
//  Created by Михаил Зиновьев on 27.11.2021.
//

import Foundation

protocol MovieListManagerDelegate {
    func didUpdateMovieList(_ movieListManager: MovieListManager, movieSearch: MovieSearch)
    func didFailWithError( error: Error)
}

struct MovieListManager {
    var delegate: MovieListManagerDelegate?
    
    private let headers = [
        "x-rapidapi-host": "movie-database-imdb-alternative.p.rapidapi.com",
        "x-rapidapi-key": "b47c20d26fmsh9a638b90d3c84fcp1de599jsn6eae9cde9d97"
    ]
    
    func fetchMovies(with seatchString: String) {
        let urlString = "https://movie-database-imdb-alternative.p.rapidapi.com/?s=Avatar&r=json&page=1"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)  {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("request perform error detected")
                    return
                }

                if let safeData = data {
                    if let movieSearch = self.parseJSON(safeData){
                        self.delegate?.didUpdateMovieList(self, movieSearch: movieSearch)
                    }
                }
            }
            task.resume()
        }
        
//
//        let request = NSMutableURLRequest(url: NSURL(string: "https://movie-database-imdb-alternative.p.rapidapi.com/?s=Avatar&r=json&page=1")! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error)
//            } else {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse)
//            }
//        })
//
//        dataTask.resume()
        
        
    }
    
    func parseJSON(_ movieSearchData: Data) -> MovieSearch?{
        let decoder = JSONDecoder()
        do {
            print("")
            print(String(decoding: movieSearchData, as: UTF8.self))
            print("")
            let decodedData = try decoder.decode(MovieSearch.self, from: movieSearchData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            print("parse error detected")
            return nil
        }
    }
}
