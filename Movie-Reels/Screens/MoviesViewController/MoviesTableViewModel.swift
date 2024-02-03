//
//  MoviesTableViewModel.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import Foundation

protocol MoviesTableViewModelDelegate: AnyObject {
    func updateMovies()
    func updateError()
}

protocol MoviesTableViewModeling {
    var moviesViewModels: [MovieViewModel] { get }
    var lastErrorMessage: String? { get }
    
    func loadMovies()
    func configure(details: MovieDetailsPresentable, for index: IndexPath)
    func configure(favorites: FavoriteMoviesPresentable, for index: IndexPath)
}

class MoviesTableViewModel: MoviesTableViewModeling {
    
    var isLoading = false
    var moviesViewModels: [MovieViewModel] = []
    var lastErrorMessage: String?
    
    weak var delegate: MoviesTableViewModelDelegate?
    let localStorage = CoreDataController.shared
    
    private lazy var fallbackController: FallbackController = {
        FallbackController(
            mainSource: NetworkController(),
            reserveSource: localStorage)
    }()
    
    func loadMovies() {
        fallbackController.loadMovies { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
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
    
    func configure(details: MovieDetailsPresentable, for index: IndexPath) {
        let cellViewModel = moviesViewModels[index.row]
        cellViewModel.configure(details: details)
    }
    
    func configure(favorites: FavoriteMoviesPresentable, for index: IndexPath) {
        let cellViewModel = moviesViewModels[index.row]
        var newMovies: [Movie] = []
        
        localStorage.loadFavoriteMovies { [weak self] result in
            guard let self else { return }
            
            do {
                let favoriteMovies = try result.get()
                
                newMovies.append(contentsOf: favoriteMovies)
                newMovies.append(cellViewModel.movie)
                localStorage.storeFavoriteMovies(movies: newMovies)
                
                favorites.addMovie(movie: cellViewModel)
                
            } catch {
                self.lastErrorMessage = error.localizedDescription
            }
        }
    }
}