//
//  MovieViewModel.swift
//  Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import Foundation
import CoreData

protocol MovieViewModelDelegate: AnyObject {
    func updateMovieDate()
    func updateImage()
    func updateLoadingState()
}

protocol MovieViewModeling {
    var id: Int { get }
    var title: String { get }
    var posterData: Data? { get }
    var isImageLoading: Bool { get }
    var releaseDate: String { get }
    
    func loadImage()
    func storeMoviePoster<T: NSManagedObject & MovieEntity>(for entityType: T.Type, entityName: String)
    func updateGenres(for genreIds: [Int], genres: [Genre])
    func configure(details: MovieDetailsPresentable)
}

class MovieViewModel: MovieViewModeling {
    let movie: Movie
    var id: Int { movie.id }
    var title: String { movie.title }
    var releaseDate: String { movie.releaseDate }
    
    var posterData: Data?
    var genres: [String] = []
    var isImageLoading: Bool = false
    
    lazy var imageFetchingController = NetworkController()
    lazy var localStorage = CoreDataController.shared
    weak var delegate: MovieViewModelDelegate?
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func loadImage() {
        guard !movie.poster.isEmpty, isImageLoading == false, posterData == nil else { return }
        
        isImageLoading = true
        delegate?.updateLoadingState()
        
        let imagePath = imageFetchingController.baseImagePath + movie.poster
        
        imageFetchingController.loadData(fullPath: imagePath) { [weak self] result in
            guard let self else { return }
            
            let posterData: Data?
            
            do {
                posterData = try result.get()
            } catch {
                posterData = self.movie.posterData
            }
            
            self.posterData = posterData
            self.delegate?.updateImage()
            self.isImageLoading = false
            self.delegate?.updateLoadingState()
        }
    }
    
    func storeMoviePoster<T: NSManagedObject & MovieEntity>(for entityType: T.Type, entityName: String) {
        if let posterData {
            self.localStorage.storeMoviePoster(movieID: self.id, posterData: posterData, entityType: entityType, entityName: entityName)
        }
    }
    
    func updateGenres(for genreIds: [Int], genres: [Genre]) {
        let nameGenres = genres.filter({ self.movie.genreIds.contains($0.id) }).map{ $0.name }
        self.genres = nameGenres.sorted(by: <)
    }
    
    func configure(details: MovieDetailsPresentable) {
        details.update(movie: movie)
    }
    
    func configure(favorites: FavoriteMoviesPresentable) {
        favorites.addFavoriteMovie(movie: movie)
        storeMoviePoster(for: FavoritesMovieCD.self, entityName: Constants.favoritesMovieEntityName)
    }
}
