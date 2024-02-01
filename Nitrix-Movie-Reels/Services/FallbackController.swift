//
//  FallbackController.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 01.02.2024.
//

import Foundation

final class FallbackController: MoviesLoading {
    let mainSource: MoviesLoading
    let reserveSource: MoviesLoading & MoviesStoring
    
    init(mainSource: MoviesLoading, reserveSource: MoviesLoading & MoviesStoring) {
        self.mainSource = mainSource
        self.reserveSource = reserveSource
    }
    
    func loadMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        mainSource.loadMovies { result in
            do {
                let movies = try result.get()
                
                if movies.isEmpty {
                    completion(.failure(NetErrors.invalidData))
                    return
                }
                
                self.reserveSource.storeMovies(movies: movies)
                completion(.success(movies))
            } catch {
                self.reserveSource.loadMovies { reserveResult in
                    do {
                        let reserveMovies = try reserveResult.get()
                        completion(.success(reserveMovies))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
