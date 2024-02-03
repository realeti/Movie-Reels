//
//  NetworkController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import Foundation

enum NetErrors: Error {
    case statusCode(Int)
    case invalidURL
    case invalidData
    case badResponse
    case wrongDecode
    case connectionProblem
}

protocol MoviesLoading {
    func loadMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
}

class NetworkController: MoviesLoading {
    
    let session = URLSession.shared
    
    lazy var decoder = JSONDecoder()
    
    let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyY2NjOWZjYjNlODg2ZmNiNWY4MDAxNTQxODczNTA 5NSIsInN1YiI6IjY1Yjc0MTJiYTBiNjkwMDE3YmNlZjhmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJ dLCJ2ZXJzaW9uIjoxfQ.Hhl93oP6hoKiYuXMis5VT-MVRfv1KZXhJjSncyCkhpw"
    ]
    
    let baseUrlString = "https://api.themoviedb.org/"
    let baseImagePath = "https://image.tmdb.org/t/p/w500"
    let apiKey = "2ccc9fcb3e886fcb5f80015418735095"
    
    func loadData(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = baseUrlString.appending(path)
        self.loadData(fullPath: urlString, completion: completion)
    }
    
    func loadData(fullPath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: fullPath) else {
            completion(.failure(NetErrors.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(NetErrors.connectionProblem))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetErrors.badResponse))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (200..<300).contains(statusCode) else {
                completion(.failure(NetErrors.statusCode(statusCode)))
                return
            }
            
            guard let data else {
                completion(.failure(NetErrors.invalidData))
                return
            }
            
            completion(.success(data))
        }
        dataTask.resume()
    }
    
    func loadMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let path = "3/trending/movie/week?language=en-US&api_key=\(apiKey)"
        
        loadData(path: path) { response in
            do {
                let data = try response.get()
                let responseData = try self.decoder.decode(MovieListDTO.self, from: data)
                let moviesDto = responseData.results
                
                let movies = moviesDto.map { movie in
                    Movie(id: movie.id,
                          title: movie.title,
                          poster: movie.poster,
                          releaseDate: movie.releaseDate,
                          overview: movie.overview
                    )
                }
                
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
