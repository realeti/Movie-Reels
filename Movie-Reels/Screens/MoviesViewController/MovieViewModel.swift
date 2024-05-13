//
//  MovieViewModel.swift
//  Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import UIKit
import CoreData

protocol MovieViewModelDelegate: AnyObject {
    func updateImage()
    func updateLoadingState()
}

protocol MovieViewModeling {
    var id: Int { get }
    var title: String { get }
    var moviePoster: UIImage? { get }
    var movieGenres: [String] { get }
    var isImageLoading: Bool { get }
    var releaseDate: String { get }
    var voteAverage: Float { get }
    
    func loadImage()
    func storeMoviePoster()
    func configure(details: MovieDetailsPresentable)
}

class MovieViewModel: MovieViewModeling {
    let movie: Movie
    var id: Int { movie.id }
    var title: String { movie.title }
    var releaseDate: String { movie.releaseDate }
    var voteAverage: Float { movie.voteAverage }
    
    var moviePoster: UIImage?
    var movieGenres: [String] = []
    var isImageLoading: Bool = false
    
    lazy var imageFetchingController = NetworkController()
    lazy var imageStorage = FileManagerController.shared
    weak var delegate: MovieViewModelDelegate?
    
    init(movie: Movie, genres: [String]) {
        self.movie = movie
        self.movieGenres = genres
    }
    
    func loadImage() {
        guard !movie.poster.isEmpty, isImageLoading == false, moviePoster == nil else { return }
        isImageLoading = true
        delegate?.updateLoadingState()
        
        let imagePath = imageFetchingController.baseImagePath + movie.poster
        
        imageFetchingController.loadData(fullPath: imagePath) { [unowned self] result in
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
    
    func configure(details: MovieDetailsPresentable) {
        details.update(movie: movie)
    }
    
    func configure(favorites: FavoriteMoviesPresentable) {
        favorites.addFavoriteMovie(movie: movie, genres: movieGenres)
        storeMoviePoster()
    }
}
