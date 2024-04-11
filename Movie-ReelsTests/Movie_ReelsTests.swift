//
//  Movie_ReelsTests.swift
//  Movie-ReelsTests
//
//  Created by Apple M1 on 11.04.2024.
//

import XCTest

@testable import Movie_Reels

final class MoviesLoadingFailureMockTests: XCTestCase {
    
    func testLoadMoviesFailure() {
        // Arrange
        let mock = MoviesLoadingFailureMock()
        var receivedError: Error?
        
        // Act
        mock.loadMovies { result in
            if case let .failure(error) = result {
                receivedError = error
            }
        }
        
        // Assert
        XCTAssertNotNil(receivedError)
        XCTAssertTrue(receivedError is MoviesLoadingFailureMock.MockError)
        XCTAssertEqual(receivedError as? MoviesLoadingFailureMock.MockError, .mockMovies)
    }
    
    func testLoadGenresFailure() {
        // Arrange
        let mock = MoviesLoadingFailureMock()
        var receivedError: Error?
        
        // Act
        mock.loadMovieGenres { result in
            if case let .failure(error) = result {
                receivedError = error
            }
        }
        
        // Assert
        XCTAssertNotNil(receivedError)
        XCTAssertTrue(receivedError is MoviesLoadingFailureMock.MockError)
        XCTAssertEqual(receivedError as? MoviesLoadingFailureMock.MockError, .mockGenres)
    }
    
    func testStoreMoviesSuccess() {
        // Arrange
        let mock = MoviesLoadingFailureMock()
        let moviesToStore: [Movie] = []
        
        // Act
        mock.storeMovies(movies: moviesToStore)
        
        // Assert
        XCTAssertEqual(mock.lastStoredMovies, moviesToStore, "The movies array must be empty")
    }
    
    func testStoreGenres() {
        // Arrange
        let mock = MoviesLoadingFailureMock()
        let genresToStore: [Genre] = []
        
        // Act
        mock.storeGenres(genres: genresToStore)
        
        // Assert
        XCTAssertEqual(mock.lastStoreGenres, genresToStore, "The genres array must be empty")
    }
}
