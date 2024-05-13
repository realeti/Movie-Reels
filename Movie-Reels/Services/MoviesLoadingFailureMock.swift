//
//  MoviesLoadingFailureMock.swift
//  Movie-Reels
//
//  Created by Apple M1 on 22.03.2024.
//

import Foundation

final class MoviesLoadingFailureMock: MoviesLoading, MoviesStoring {
    enum MockError: Error {
        case mockMovies
        case mockGenres
    }
    
    var lastStoredMovies: [Movie] = []
    var lastStoreGenres: [Genre] = []
    
    func loadNewMovies(pageNum: Int, completion: @escaping (Result<[Movie], any Error>) -> Void) {
        completion(.failure(MockError.mockMovies))
    }
    
    func loadMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        completion(.failure(MockError.mockMovies))
    }
    
    func loadPopularMovies(pageNum: Int, completion: @escaping (Result<[Movie], any Error>) -> Void) {
        completion(.failure(MockError.mockMovies))
    }
    
    func loadMovieGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        completion(.failure(MockError.mockGenres))
    }
    
    func storeMovies(movies: [Movie]) {
        lastStoredMovies = movies
    }
    
    func storeGenres(genres: [Genre]) {
        lastStoreGenres = genres
    }
}
