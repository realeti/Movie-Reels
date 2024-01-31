//
//  DetailsViewModel.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import Foundation

protocol DetailsViewModelDelegate: AnyObject {
    func updateImage()
    func updateError()
    func updateLoadingState()
}

protocol DetailsViewModeling {
    var title: String { get }
    var imageData: Data? { get }
    var isImageLoading: Bool { get }
    var relaseDate: String { get }
    var overview: String { get }
    var lastErrorMessage: String? { get }
    
    func loadImage()
    func update(movie: Movie)
}

class DetailsViewModel: DetailsViewModeling {
    private var movie: Movie?
    
    var title: String { movie?.title ?? "" }
    var imageData: Data?
    var isImageLoading: Bool = false
    var relaseDate: String { movie?.releaseDate ?? ""}
    var overview: String { movie?.overview ?? "" }
    var lastErrorMessage: String?
    
    lazy var imageFetchingController = NetworkController()
    weak var delegate: DetailsViewModelDelegate?
    
    func loadImage() {
        lastErrorMessage = nil
        
        guard let movie, isImageLoading == false, imageData == nil else { return }
        
        isImageLoading = true
        delegate?.updateLoadingState()
        
        let imagePath = imageFetchingController.baseImagePath + movie.poster
        imageFetchingController.loadData(fullPath: imagePath) { [weak self] in
            self?.isImageLoading = false
            
            self?.delegate?.updateLoadingState()
            do {
                self?.imageData = try $0.get()
            } catch {
                self?.lastErrorMessage = error.localizedDescription
                self?.delegate?.updateError()
            }
        }
    }
    
    func update(movie: Movie) {
        self.movie = movie
        self.imageData = nil
        self.loadImage()
    }

}
