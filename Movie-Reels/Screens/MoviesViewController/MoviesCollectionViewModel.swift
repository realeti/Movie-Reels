//
//  MoviesCollectionViewModel.swift
//  Movie-Reels
//
//  Created by Apple M1 on 18.04.2024.
//

import Foundation

protocol MoviesCollectionViewModelDelegate {
    func updateMovies()
    func updateError()
}

protocol MoviesCollectionViewModeling {
    var moviesViewModels: [MovieViewModel] { get }
    var movieGenres: [Genre] { get }
    var lastErrorMessage: String? { get }
    
    func loadMoviesData()
    func loadMovies(completion: @escaping () -> Void)
    func loadMovieGenres()
}
