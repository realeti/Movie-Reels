//
//  MoviesLoadingMock.swift
//  Movie-Reels
//
//  Created by Apple M1 on 22.03.2024.
//

import Foundation

final class MoviesLoadingMock: MoviesLoading, MoviesStoring {
    
    let mockedMoviesResults = [
        Movie(
            id: 1,
            title: "MockMovie1",
            poster: "",
            releaseDate: "01.01.2000",
            overview: "MockOverview1",
            genreIds: [0, 1]
        ),
        Movie(
            id: 2,
            title: "MockMovie2",
            poster: "",
            releaseDate: "01.01.2000",
            overview: "MockOverview2",
            genreIds: [0, 1]
        )
    ]
    
    let mockedGenresResults = [
        Genre(
            id: 0,
            name: "MockGenre1"
        ),
        Genre(
            id: 1,
            name: "MockGenre2"
        )
    ]
    
    var lastStoredMovies: [Movie] = []
    var lastStoredGenres: [Genre] = []
    
    func loadMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        completion(.success(mockedMoviesResults))
    }
    
    func loadMovieGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        completion(.success(mockedGenresResults))
    }
    
    func storeMovies(movies: [Movie]) {
        lastStoredMovies = movies
    }
    
    func storeGenres(genres: [Genre]) {
        lastStoredGenres = genres
    }
}
