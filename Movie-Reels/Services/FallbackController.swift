//
//  FallbackController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 01.02.2024.
//

import Foundation
import CoreData

final class FallbackController: MoviesLoading {
    let mainSource: MoviesLoading
    let reserveSource: MoviesLoadingStorage & MoviesStoring
    
    init(mainSource: MoviesLoading, reserveSource: MoviesLoadingStorage & MoviesStoring) {
        self.mainSource = mainSource
        self.reserveSource = reserveSource
    }
    
    func loadNewMovies(pageNum: Int = 1, completion: @escaping (Result<[Movie], any Error>) -> Void) {
        mainSource.loadNewMovies(pageNum: pageNum) { result in
            do {
                let movies = try result.get()
                
                if movies.isEmpty {
                    completion(.failure(NetErrors.invalidData))
                    return
                }
                
                self.reserveSource.storeMovies(movies: movies)
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }
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
                self.reserveSource.loadMovies(entityType: MovieCD.self, entityName: Constants.movieEntityName) { result in
                    do {
                        let reserveMovies = try result.get()
                        completion(.success(reserveMovies))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func loadPopularMovies(pageNum: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        mainSource.loadPopularMovies(pageNum: pageNum) { result in
            do {
                let movies = try result.get()
                
                if movies.isEmpty {
                    completion(.failure(NetErrors.invalidData))
                    return
                }
                
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func loadMovieGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        mainSource.loadMovieGenres { result in
            do {
                let genres = try result.get()
                
                if genres.isEmpty {
                    completion(.failure(NetErrors.invalidData))
                    return
                }
                
                self.reserveSource.storeGenres(genres: genres)
                completion(.success(genres))
            } catch {
                self.reserveSource.loadMovieGenres { result in
                    do {
                        let genres = try result.get()
                        completion(.success(genres))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
