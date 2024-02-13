//
//  FavoriteMovieTableViewModel.swift
//  Movie-Reels
//
//  Created by Apple M1 on 01.02.2024.
//

import Foundation

protocol FavoriteMoviesPresentable {
    func addFavoriteMovie(movie: Movie)
}

protocol FavoriteMovieTableViewModelDelegate: AnyObject {
    func updateMovies()
    func updateError()
}

protocol FavoriteMovieTableViewModeling {
    var moviesViewModels: [MovieViewModel] { get }
    var movieGenres: [Genre] { get }
    var lastErrorMessage: String? { get }
    
    func loadMoviesData()
    func loadMovies(completion: @escaping () -> Void)
    func loadMovieGenres()
    func removeFavoriteMovie(for index: IndexPath)
    func configure(details: MovieDetailsPresentable, for index: IndexPath)
}

class FavoriteMovieTableViewModel: FavoriteMovieTableViewModeling, FavoriteMoviesPresentable {
    
    var moviesViewModels: [MovieViewModel] = []
    var movieGenres: [Genre] = []
    var lastErrorMessage: String?
    
    weak var delegate: FavoriteMovieTableViewModelDelegate?
    lazy var localStorage = CoreDataController.shared
    
    func loadMoviesData() {
        loadMovies { [weak self] in
            guard let self else { return }
            self.loadMovieGenres()
        }
    }
    
    func loadMovies(completion: @escaping () -> Void) {
        localStorage.loadMovies(entityType: FavoritesMovieCD.self, entityName: Constants.favoritesMovieEntityName) { [weak self] result in
            guard let self else { return }
            
            do {
                let movies = try result.get()
                let viewModels = movies.map { MovieViewModel(movie: $0) }
                
                self.moviesViewModels = []
                self.moviesViewModels.append(contentsOf: viewModels)
                completion()
            } catch {
                self.lastErrorMessage = error.localizedDescription
                self.delegate?.updateError()
            }
        }
    }
    
    func loadMovieGenres() {
        localStorage.loadMovieGenres { [weak self] result in
            guard let self else { return }
            
            do {
                let genres = try result.get()
                
                self.moviesViewModels.forEach { movieViewModel in
                    movieViewModel.updateGenres(for: movieViewModel.movie.genreIds, genres: genres)
                }
                
                movieGenres = genres
                self.delegate?.updateMovies()
            } catch {
                self.lastErrorMessage = error.localizedDescription
                self.delegate?.updateError()
            }
        }
    }
    
    func addFavoriteMovie(movie: Movie) {
        let newFavoriteMovie = MovieViewModel(movie: movie)
        let existingMovie = moviesViewModels.firstIndex(where: { $0.title == newFavoriteMovie.title })
        
        if let existingMovie {
            self.moviesViewModels.remove(at: existingMovie)
        }
        
        newFavoriteMovie.updateGenres(for: movie.genreIds, genres: movieGenres)
        
        self.moviesViewModels.append(newFavoriteMovie)
        self.delegate?.updateMovies()
        
        localStorage.addFavoriteMovie(movie: newFavoriteMovie.movie) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func removeFavoriteMovie(for index: IndexPath) {
        let removedMovie = moviesViewModels[index.row].movie
        moviesViewModels.remove(at: index.row)
        
        localStorage.removeFavoriteMovie(movieID: removedMovie.id) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func configure(details: MovieDetailsPresentable, for index: IndexPath) {
        let cellViewModel = moviesViewModels[index.row]
        cellViewModel.configure(details: details)
    }
}
