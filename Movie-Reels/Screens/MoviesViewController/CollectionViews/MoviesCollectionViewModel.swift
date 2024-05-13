//
//  MoviesCollectionViewModel.swift
//  Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import Foundation

protocol MoviesCollectionViewModelDelegate: AnyObject {
    func updateNewMovies()
    func updateMovies()
    func updatePopularMovies()
    func updateError()
}

protocol MoviesCollectionViewModeling {
    var moviesViewModels: [SectionIdentifier: [MovieViewModel]] { get }
    var movieGenres: [Genre] { get }
    var lastErrorMessage: String? { get }
    
    func loadMoviesData()
    func loadMovies(completion: @escaping () -> Void)
    func loadMovieGenres(completion: @escaping () -> Void)
    func configure(details: MovieDetailsPresentable, section: SectionIdentifier, for index: IndexPath)
    func configure(favorites: FavoriteMoviesPresentable, section: SectionIdentifier, for index: IndexPath)
}

enum SectionIdentifier: String {
    case playingNow = "New films"
    case trending = "Trending now"
    case popular = "Most popular"
    
    var sectionTitle: String {
        return self.rawValue
    }
}

class MoviesCollectionViewModel: MoviesCollectionViewModeling {
    
    var isLoading = false
    var moviesViewModels: [SectionIdentifier: [MovieViewModel]] = [:]
    var movieGenres: [Genre] = []
    var lastErrorMessage: String?
    
    weak var delegate: MoviesCollectionViewModelDelegate?
    
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
            
            self.loadNewMovies(pageNum: 1) {
                self.delegate?.updateNewMovies()
            }
            
            self.loadMovies {
                self.delegate?.updateMovies()
            }
            
            self.loadPopularMovies(pageNum: 1) {
                self.delegate?.updatePopularMovies()
            }
        }
    }
    
    func loadNewMovies(pageNum: Int, completion: @escaping () -> Void) {
        fallbackController.loadNewMovies { [weak self] result in
            guard let self else { return }
            
            do {
                let movies = try result.get()
                let viewModels = movies.map { movie in
                    let genresForMovie = self.movieGenres.filter({ movie.genreIds.contains($0.id) }).map { $0.name }.sorted(by: <)
                    return MovieViewModel(movie: movie, genres: genresForMovie)
                }
                
                self.moviesViewModels[SectionIdentifier.playingNow] = viewModels
                completion()
            } catch {
                self.lastErrorMessage = error.localizedDescription
                self.delegate?.updateError()
            }
        }
    }
    
    func loadMovies(completion: @escaping () -> Void) {
        fallbackController.loadMovies { [weak self] result in
            guard let self else { return }
            
            do {
                let movies = try result.get()
                let viewModels = movies.map { movie in
                    let genresForMovie = self.movieGenres.filter({ movie.genreIds.contains($0.id) }).map{ $0.name }.sorted(by: <)
                    return MovieViewModel(movie: movie, genres: genresForMovie)
                }
                
                self.moviesViewModels[SectionIdentifier.trending] = viewModels
                completion()
            } catch {
                self.lastErrorMessage = error.localizedDescription
                self.delegate?.updateError()
            }
        }
    }
    
    func loadPopularMovies(pageNum: Int, completion: @escaping () -> Void) {
        fallbackController.loadPopularMovies(pageNum: pageNum) { [weak self] result in
            guard let self else { return }
            
            do {
                let movies = try result.get()
                let viewModels = movies.map { movie in
                    let genresForMovie = self.movieGenres.filter({ movie.genreIds.contains($0.id) }).map{ $0.name }.sorted(by: <)
                    return MovieViewModel(movie: movie, genres: genresForMovie)
                }
                
                self.moviesViewModels[SectionIdentifier.popular] = viewModels
                completion()
            } catch {
                self.lastErrorMessage = error.localizedDescription
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
    
    func configure(details: MovieDetailsPresentable, section: SectionIdentifier, for index: IndexPath) {
        let cellViewModel = moviesViewModels[section]?[index.row]
        cellViewModel?.configure(details: details)
    }
    
    func configure(favorites: FavoriteMoviesPresentable, section: SectionIdentifier, for index: IndexPath) {
        let cellViewModel = moviesViewModels[section]?[index.row]
        cellViewModel?.configure(favorites: favorites)
    }
}
