//
//  MovieViewModel.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import Foundation

protocol MovieViewModelDelegate: AnyObject {
    func updateMovieDate()
    func updateImage()
    func updateLoadingState()
}

protocol MovieViewModeling {
    var title: String { get }
    var imageData: Data? { get }
    var isImageLoading: Bool { get }
    var releaseDate: String { get }
    
    func loadImage()
    func configure(details: MovieDetailsPresentable)
}

class MovieViewModel: MovieViewModeling {
    let movie: Movie
    var title: String { movie.title }
    var releaseDate: String { movie.releaseDate }
    
    var imageData: Data?
    var isImageLoading: Bool = false
    
    lazy var imageFetchingController = NetworkController()
    lazy var localStorage = CoreDataController.shared
    weak var delegate: MovieViewModelDelegate?
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func loadImage() {
        guard !movie.poster.isEmpty, isImageLoading == false, imageData == nil else { return }
        
        isImageLoading = true
        delegate?.updateLoadingState()
        
        let imagePath = imageFetchingController.baseImagePath + movie.poster
        imageFetchingController.loadData(fullPath: imagePath) { [weak self] in
            self?.imageData = try? $0.get()
            self?.delegate?.updateImage()

            self?.isImageLoading = false
            self?.delegate?.updateLoadingState()
        }
    }
    
    func configure(details: MovieDetailsPresentable) {
        details.update(movie: movie)
    }
}
