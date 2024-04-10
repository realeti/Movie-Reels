//
//  MovieViewModel.swift
//  Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import UIKit
import CoreData

protocol MovieViewModelDelegate: AnyObject {
    func updateMovieDate()
    func updateImage()
    func updateLoadingState()
}

protocol MovieViewModeling {
    var id: Int { get }
    var title: String { get }
    var moviePoster: UIImage? { get }
    var isImageLoading: Bool { get }
    var releaseDate: String { get }
    
    func loadImage()
    func storeMoviePoster()
    func updateGenres(for genreIds: [Int], genres: [Genre])
    func configure(details: MovieDetailsPresentable)
}

class MovieViewModel: MovieViewModeling {
    let movie: Movie
    var id: Int { movie.id }
    var title: String { movie.title }
    var releaseDate: String { movie.releaseDate }
    
    var moviePoster: UIImage?
    var genres: [String] = []
    var isImageLoading: Bool = false
    
    lazy var imageFetchingController = NetworkController()
    lazy var imageStorage = FileManagerController.shared
    weak var delegate: MovieViewModelDelegate?
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func loadImage() {
        guard !movie.poster.isEmpty, isImageLoading == false, moviePoster == nil else { return }
        
        isImageLoading = true
        delegate?.updateLoadingState()
        
        let imagePath = imageFetchingController.baseImagePath + movie.poster
        
        imageFetchingController.loadData(fullPath: imagePath) { [weak self] result in
            guard let self else { return }
            
            do {
                let imageData = try result.get()
                moviePoster = UIImage(data: imageData)
                storeMoviePoster()
            } catch {
                let imageName = "poster_\(title)"
                moviePoster = imageStorage.loadImage(withName: imageName)
            }
            
            self.delegate?.updateImage()
            self.isImageLoading = false
            self.delegate?.updateLoadingState()
        }
    }
    
    func storeMoviePoster() {
        guard let image = moviePoster else {
            return
        }
        
        let imageName = "poster_\(title)"
        imageStorage.saveImage(image, withName: imageName)
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
        storeMoviePoster()
    }
}
