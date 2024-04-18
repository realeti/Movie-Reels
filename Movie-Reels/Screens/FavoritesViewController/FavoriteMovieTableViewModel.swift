//
//  FavoriteMovieTableViewModel.swift
//  Movie-Reels
//
//  Created by Apple M1 on 01.02.2024.
//

import Foundation

protocol FavoriteMoviesPresentable {
    func addFavoriteMovie(movie: Movie, genres: [String])
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
    func loadMovieGenres(completion: @escaping () -> Void)
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
        loadMovieGenres { [weak self] in
            guard let self else { return }
            
            self.loadMovies {
                self.delegate?.updateMovies()
            }
        }
    }
    
    func loadMovies(completion: @escaping () -> Void) {
        localStorage.loadMovies(entityType: FavoritesMovieCD.self, entityName: Constants.favoritesMovieEntityName) { [weak self] result in
            guard let self else { return }
            
            do {
                let movies = try result.get()
                let viewModels = movies.map { movie in
                    let genresForMovie = self.movieGenres.filter( {movie.genreIds.contains($0.id) }).map{ $0.name }.sorted(by: <)
                    
                    return MovieViewModel(movie: movie, genres: genresForMovie)
                }
                
                self.moviesViewModels.removeAll()
                self.moviesViewModels.append(contentsOf: viewModels)
                completion()
            } catch {
                self.lastErrorMessage = error.localizedDescription
                self.delegate?.updateError()
            }
        }
    }
    
    func loadMovieGenres(completion: @escaping () -> Void) {
        localStorage.loadMovieGenres { [weak self] result in
            guard let self else { return }
            
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
    
    func addFavoriteMovie(movie: Movie, genres: [String]) {
        let newFavoriteMovie = MovieViewModel(movie: movie, genres: genres)
        
        if let existingMovieIndex = moviesViewModels.firstIndex(where: { $0.id == newFavoriteMovie.id }) {
            moviesViewModels[existingMovieIndex] = newFavoriteMovie
        } else {
            moviesViewModels.append(newFavoriteMovie)
        }
        
        self.delegate?.updateMovies()
        
        localStorage.storeFavoriteMovie(movie: newFavoriteMovie.movie) { error in
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
