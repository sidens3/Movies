//
//  NetworkManager.swift
//  Movies
//
//  Created by Михаил Зиновьев on 27.11.2021.
//

import Foundation

protocol MovieListNetworkManagerDelegate {
    func didUpdateMovieList(movieSearch: MovieSearch)
    func didFailWithError( error: Error?)
}

class NetworkManager {
    var delegate: MovieListNetworkManagerDelegate?
    
    private let headers = [
        "x-rapidapi-host": "movie-database-imdb-alternative.p.rapidapi.com",
        "x-rapidapi-key": "b47c20d26fmsh9a638b90d3c84fcp1de599jsn6eae9cde9d97"
    ]
    
    func fetchMovies(with searchString: String) {
        let formatedSearchString = searchString.trimmingCharacters(in: .whitespaces).escapeSpace()
        let urlString = "https://movie-database-imdb-alternative.p.rapidapi.com/?s=\(formatedSearchString)&r=json&page=1"
        print(urlString)
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)  {
        
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError(error: nil)
            return
        }

        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                print("request perform error detected")
                return
            }

            if let safeData = data {
                if let movieSearch = self.parseJSON(safeData){
                    self.delegate?.didUpdateMovieList(movieSearch: movieSearch)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ movieSearchData: Data) -> MovieSearch?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieSearch.self, from: movieSearchData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            print("parse error detected")
            return nil
        }
    }
}

private extension String {
    func escapeSpace() -> String {
        self.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
    }
}
