//
//  MoviesTableViewModel.swift
//  Movie-Reels
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
    
    func loadMoviesData()
    func loadMovies(completion: @escaping () -> Void)
    func loadMovieGenres()
    func configure(details: MovieDetailsPresentable, for index: IndexPath)
    func configure(favorites: FavoriteMoviesPresentable, for index: IndexPath)
}

class MoviesTableViewModel: MoviesTableViewModeling {
    
    var isLoading = false
    var moviesViewModels: [MovieViewModel] = []
    var lastErrorMessage: String?
    
    weak var delegate: MoviesTableViewModelDelegate?
    
    private lazy var fallbackController: FallbackController = {
        FallbackController(
            mainSource: NetworkController(),
            reserveSource: CoreDataController.shared)
    }()
    
    func loadMoviesData() {
        guard !isLoading else { return }
        self.isLoading = true
        
        loadMovies { [weak self] in
            guard let self else { return }
            self.loadMovieGenres()
            
            if let _ = self.lastErrorMessage {
                self.delegate?.updateError()
            }
        }
    }
    
    func loadMovies(completion: @escaping () -> Void) {
        fallbackController.loadMovies { [weak self] result in
            guard let self else { return }
            
            do {
                let movies = try result.get()
                let viewModels = movies.map { MovieViewModel(movie: $0) }
                
                self.moviesViewModels.append(contentsOf: viewModels)
                completion()
            } catch {
                self.lastErrorMessage = error.localizedDescription
            }
        }
    }
    
    func loadMovieGenres() {
        fallbackController.loadMovieGenres { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
            do {
                let genres = try result.get()
                
                self.moviesViewModels.forEach { movieViewModel in
                    let genres = genres.filter({ movieViewModel.movie.genreIds.contains($0.id) }).map{ $0.name }
                    movieViewModel.genres = genres
                }
                self.delegate?.updateMovies()
            } catch {
                self.lastErrorMessage = error.localizedDescription
            }
        }
    }
    
    func configure(details: MovieDetailsPresentable, for index: IndexPath) {
        let cellViewModel = moviesViewModels[index.row]
        cellViewModel.configure(details: details)
    }
    
    func configure(favorites: FavoriteMoviesPresentable, for index: IndexPath) {
        let cellViewModel = moviesViewModels[index.row]
        cellViewModel.configure(favorites: favorites)
    }
}
