//
//  NetworkManager.swift
//  Movies
//
//  Created by Михаил Зиновьев on 27.11.2021.
//

import Foundation
import Alamofire

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
    
    private let httpHeaders: HTTPHeaders = [
        "x-rapidapi-host": "movie-database-imdb-alternative.p.rapidapi.com",
        "x-rapidapi-key": "b47c20d26fmsh9a638b90d3c84fcp1de599jsn6eae9cde9d97"
    ]
    
    func fetchMovies(with searchString: String, with completion: @escaping(Result<MovieSearch, NetworkError>) -> Void ) {
        let formatedSearchString = searchString.trimmingCharacters(in: .whitespaces).escapeSpace()
        let urlString = "https://movie-database-imdb-alternative.p.rapidapi.com/?s=\(formatedSearchString)&r=json&page=1"
        
        performManualAlamofireRequest(with: urlString, with: completion)
    }
    
    func fetchMoviePage(for id: String, with completion: @escaping(Result<MovieSearch, NetworkError>) -> Void ) {
        let ID = "tt4154796"
        let urlString = "https://movie-database-imdb-alternative.p.rapidapi.com/?r=json&i=\(ID)"
        
        performAlamofireRequest(with: urlString, with: completion)
    }
}

//MARK: - Private Methods
private extension NetworkManager {
    //Alamofire request with manual parse
    func performManualAlamofireRequest(with urlString: String, with completion: @escaping(Result<MovieSearch, NetworkError>) -> Void )  {
        AF.request(urlString, headers: httpHeaders)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                
                case .success(let movieSearchData):
                    let searchResponse = MovieSearch.getMovieSearch(from: movieSearchData)
                    completion(.success(searchResponse))
                    
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
    
    //Alamofire request with automatic parse
    func performAlamofireRequest<T: Decodable>(with urlString: String, with completion: @escaping(Result<T, NetworkError>) -> Void )  {
        AF.request(urlString, headers: httpHeaders)
            .validate()
            .responseDecodable(of: T.self) { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    completion(.success(value))
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
    
    //URLSession request
    func performRequest<T: Decodable>(with urlString: String, with completion: @escaping(Result<T, NetworkError>) -> Void )  {
        
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

//MARK: - String
private extension String {
    func escapeSpace() -> String {
        self.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
    }
}
