//
//  DetailsViewModel.swift
//  Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import Foundation

protocol MovieDetailsPresentable {
    func update(movie: Movie)
}

protocol MovieTrailerPresentable {
    func loadTrailer(key: String)
}

protocol DetailsViewModelDelegate: AnyObject {
    func updateImage()
    func updateError()
    func updateLoadingState()
}

protocol DetailsViewModeling {
    var title: String { get }
    var imageData: Data? { get }
    var isImageLoading: Bool { get }
    var releaseDate: String { get }
    var overview: String { get }
    var lastErrorMessage: String? { get }
    
    func loadImage()
    func loadTrailers()
}

class DetailsViewModel: DetailsViewModeling, MovieDetailsPresentable {
    private var movie: Movie?
    
    var title: String { movie?.title ?? "" }
    var imageData: Data?
    var isImageLoading: Bool = false
    var releaseDate: String { movie?.releaseDate ?? ""}
    var overview: String { movie?.overview ?? "" }
    var movieTrailersKeys: [String]?
    var lastErrorMessage: String?
    
    lazy var fetchingController = NetworkController()
    weak var delegate: DetailsViewModelDelegate?
    
    func loadImage() {
        lastErrorMessage = nil
        
        guard let movie, isImageLoading == false, imageData == nil else { return }
        
        isImageLoading = true
        delegate?.updateLoadingState()
        
        let imagePath = fetchingController.baseImagePath + movie.poster
        
        fetchingController.loadData(fullPath: imagePath) { [weak self] in
            guard let self else { return }
            
            self.isImageLoading = false
            self.delegate?.updateLoadingState()
            
            do {
                self.imageData = try $0.get()
                self.delegate?.updateImage()
            } catch {
                self.lastErrorMessage = error.localizedDescription
                self.delegate?.updateError()
            }
        }
    }
    
    func loadTrailers() {
        lastErrorMessage = nil
        
        guard let movie else { return }
        
        fetchingController.loadMovieTrailers(movieId: movie.id) { [weak self] in
            guard let self else { return }
            
            do {
                let movieTrailers = try $0.get()
                
                self.movieTrailersKeys = movieTrailers.sorted(by: { $0.name < $1.name }).map({ $0.key })
            } catch {
                self.lastErrorMessage = error.localizedDescription
                self.delegate?.updateError()
            }
        }
    }
    
    func update(movie: Movie) {
        self.movie = movie
        self.imageData = nil
        self.loadImage()
        self.loadTrailers()
    }
    
    func configure(trailer: MovieTrailerPresentable, key: String) {
        trailer.loadTrailer(key: key)
    }
}
