//
//  NetworkManager.swift
//  Movies
//
//  Created by Михаил Зиновьев on 27.11.2021.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private let headers = [
        "x-rapidapi-host": "movie-database-imdb-alternative.p.rapidapi.com",
        "x-rapidapi-key": "b47c20d26fmsh9a638b90d3c84fcp1de599jsn6eae9cde9d97"
    ]
    
    func fetchMovies(with searchString: String, with completion: @escaping(Result<MovieSearch, NetworkError>) -> Void ) {
        let formatedSearchString = searchString.trimmingCharacters(in: .whitespaces).escapeSpace()
        let urlString = "https://movie-database-imdb-alternative.p.rapidapi.com/?s=\(formatedSearchString)&r=json&page=1"
        print(urlString)
        
        performRequest(with: urlString, with: completion)
    }
    
    func performRequest(with urlString: String, with completion: @escaping(Result<MovieSearch, NetworkError>) -> Void )  {
        
    guard let url = URL(string: urlString) else {
        completion(.failure(.invalidURL))
        return
    }
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            self.parseJSON(data, with: completion)
        }
        task.resume()
    }
    
    func parseJSON<T: Decodable>(_ data: Data, with completion: @escaping(Result<T, NetworkError>) -> Void ) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(.decodingError))
        }
    }
}

//MARK: - Private Methods
private extension String {
    func escapeSpace() -> String {
        self.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
    }
}
