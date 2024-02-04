//
//  MovieViewModel.swift
//  Movie-Reels
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
    var id: Int { get }
    var title: String { get }
    var posterData: Data? { get }
    var isImageLoading: Bool { get }
    var releaseDate: String { get }
    
    func loadImage()
    func configure(details: MovieDetailsPresentable)
}

class MovieViewModel: MovieViewModeling {
    let movie: Movie
    var id: Int { movie.id }
    var title: String { movie.title }
    var releaseDate: String { movie.releaseDate }
    
    var posterData: Data?
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
        imageFetchingController.loadData(fullPath: imagePath) { [weak self] in
            guard let self else { return }
            
            let posterData: Data?
            
            do {
                posterData = try $0.get()
                
                if let posterData {
                    self.localStorage.storeMoviePoster(movieID: self.id, posterData: posterData)
                }
            } catch {
                posterData = self.movie.posterData
            }
            
            if let data = posterData {
                print("LoadImage", data)
            }
            
            self.posterData = posterData
            self.delegate?.updateImage()
            self.isImageLoading = false
            self.delegate?.updateLoadingState()
        }
    }
    
    func configure(details: MovieDetailsPresentable) {
        details.update(movie: movie)
    }
}
