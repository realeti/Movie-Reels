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
    var movieGenres: [Genre] { get }
    var lastErrorMessage: String? { get }
    
    func loadMoviesData()
    func loadMovies(completion: @escaping () -> Void)
    func loadMovieGenres(completion: @escaping () -> Void)
    func configure(details: MovieDetailsPresentable, for index: IndexPath)
    func configure(favorites: FavoriteMoviesPresentable, for index: IndexPath)
}

class MoviesTableViewModel: MoviesTableViewModeling {
    
    var isLoading = false
    var moviesViewModels: [MovieViewModel] = []
    var movieGenres: [Genre] = []
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
        
        loadMovieGenres { [weak self] in
            guard let self else { return }
            
            self.loadMovies {
                self.delegate?.updateMovies()
            }
        }
    }
    
    func loadMovies(completion: @escaping () -> Void) {
        fallbackController.loadMovies { [weak self] result in
            guard let self else { return }
            
            do {
                let movies = try result.get()
                let viewModels = movies.map { movie in
                    let genresForMovie = self.movieGenres.filter( {movie.genreIds.contains($0.id) }).map{ $0.name }.sorted(by: <)
                    
                    return MovieViewModel(movie: movie, genres: genresForMovie)
                }
                
                self.moviesViewModels.append(contentsOf: viewModels)
                completion()
            } catch {
                self.lastErrorMessage = error.localizedDescription
                self.delegate?.updateError()
            }
        }
    }
    
    func loadMovieGenres(completion: @escaping () -> Void) {
        fallbackController.loadMovieGenres { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
            do {
                let genres = try result.get()
                
                self.movieGenres = genres
                completion()
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
        cellViewModel.configure(favorites: favorites)
    }
}
