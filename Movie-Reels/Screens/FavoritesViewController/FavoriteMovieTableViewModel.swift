//
//  FavoriteMovieTableViewModel.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 01.02.2024.
//

import Foundation

protocol FavoriteMoviesPresentable {
    func addMovie(movie: MovieViewModel)
}

protocol FavoriteMovieTableViewModelDelegate: AnyObject {
    func updateMovies()
    func updateError()
}

protocol FavoriteMovieTableViewModeling {
    var moviesViewModels: [MovieViewModel] { get }
    var lastErrorMessage: String? { get }
    
    func removeFavoriteMovie(for index: IndexPath)
    func configure(details: MovieDetailsPresentable, for index: IndexPath)
}

class FavoriteMovieTableViewModel: FavoriteMovieTableViewModeling, FavoriteMoviesPresentable {
    
    var moviesViewModels: [MovieViewModel] = []
    var lastErrorMessage: String?
    
    weak var delegate: FavoriteMovieTableViewModelDelegate?
    let localStorage = CoreDataController.shared
    
    func loadMovies() {
        localStorage.loadFavoriteMovies { [weak self] result in
            guard let self else { return }
            
            do {
                let movies = try result.get()
                let viewModels = movies.map { MovieViewModel(movie: $0) }
                
                self.moviesViewModels.append(contentsOf: viewModels)
                self.delegate?.updateMovies()
            } catch {
                self.lastErrorMessage = error.localizedDescription
                self.delegate?.updateError()
            }
        }
    }
    
    func removeFavoriteMovie(for index: IndexPath) {        
        let removedMovie = moviesViewModels[index.row].movie
        moviesViewModels.remove(at: index.row)
        
        localStorage.removeFavoriteMovie(withTitle: removedMovie.title) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func configure(details: MovieDetailsPresentable, for index: IndexPath) {
        let cellViewModel = moviesViewModels[index.row]
        cellViewModel.configure(details: details)
    }
    
    func addMovie(movie: MovieViewModel) {
        self.moviesViewModels.append(movie)
        self.delegate?.updateMovies()
    }
}