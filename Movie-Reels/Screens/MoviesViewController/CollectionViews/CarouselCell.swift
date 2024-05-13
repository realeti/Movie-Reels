//
//  CarouselCell.swift
//  Movie-Reels
//
//  Created by Apple M1 on 12.05.2024.
//

import UIKit
import VisualEffectView

class CarouselCell: UICollectionViewCell {
    static let reuseIdentifier = Constants.movieCarouselCellIdentifier
    
    lazy var moviePosterView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var moviePoster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.tintColor = UIColor(resource: .darkOrange)
        return indicator
    }()
    
    lazy var movieNameView: VisualEffectView = {
        let visualEffectView = VisualEffectView()
        visualEffectView.colorTint = UIColor(resource: .shadow)
        visualEffectView.colorTintAlpha = 0.5
        return visualEffectView
    }()
    
    lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    var viewModel: MovieViewModel? {
        didSet {
            guard let viewModel else { return }
            
            movieNameLabel.text = viewModel.title
            updateImage()
        }
    }
    
    var userDevice: UIUserInterfaceIdiom?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieNameLabel.text = nil
        moviePoster.image = nil
        activityIndicator.stopAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViewsCornerRadius()
        updateSizes()
    }
    
    private func updateViewsCornerRadius() {
        let device: DeviceType = userDevice == .phone ? .phone : .pad
        
        let moviePosterCornerRadius: CGFloat
        
        switch device {
        case .phone:
            moviePosterCornerRadius = self.frame.width / 15
        case .pad:
            moviePosterCornerRadius = self.frame.width / 10
        }
        
        moviePosterView.layer.cornerRadius = moviePosterCornerRadius
        moviePosterView.clipsToBounds = true
    }
    
    private func updateSizes() {
        let defaultFontSize = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        let device: DeviceType = userDevice == .phone ? .phone : .pad
        
        let movieNameSize: CGFloat
        let movieBlurRadius: CGFloat
        
        switch device {
        case .phone:
            movieNameSize = Metrics.movieNameSizeBase
            movieBlurRadius = Metrics.movieBlurPhone
        case .pad:
            movieNameSize = Metrics.movieNameSizeLarge
            movieBlurRadius = Metrics.movieBlurPad
        }
        
        movieNameLabel.font = UIFont(name: Constants.movieTitleFont, size: movieNameSize) ?? defaultFontSize
        movieNameView.blurRadius = movieBlurRadius
    }
    
    private func setupUI() {
        contentView.addSubview(moviePosterView)
        moviePosterView.addSubview(moviePoster)
        moviePosterView.addSubview(activityIndicator)
        moviePosterView.addSubview(movieNameView)
        movieNameView.contentView.addSubview(movieNameLabel)
        
        contentView.backgroundColor = .clear
        userDevice = traitCollection.userInterfaceIdiom
        
        setupMoviePosterViewConstraints()
        setupMoviePosterConstraints()
        setupActivityIndicatorConstraints()
        setupMovieNameViewConstraints()
        setupMovieNameConstraints()
    }
    
    private func setupMoviePosterViewConstraints() {
        moviePosterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moviePosterView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            moviePosterView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func setupMoviePosterConstraints() {
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: moviePosterView.topAnchor, constant: 22.0),
            moviePoster.widthAnchor.constraint(equalTo: moviePosterView.widthAnchor),
            moviePoster.heightAnchor.constraint(equalTo: moviePosterView.heightAnchor)
        ])
    }
    
    private func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: moviePoster.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: moviePoster.centerYAnchor)
        ])
    }
    
    private func setupMovieNameViewConstraints() {
        movieNameView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNameView.leadingAnchor.constraint(equalTo: moviePosterView.leadingAnchor),
            movieNameView.trailingAnchor.constraint(equalTo: moviePosterView.trailingAnchor),
            movieNameView.bottomAnchor.constraint(equalTo: moviePosterView.bottomAnchor),
            movieNameView.heightAnchor.constraint(equalTo: moviePosterView.heightAnchor, multiplier: 0.30)
        ])
    }
    
    private func setupMovieNameConstraints() {
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: movieNameView.topAnchor),
            movieNameLabel.leadingAnchor.constraint(equalTo: movieNameView.leadingAnchor, constant: 13.0),
            movieNameLabel.trailingAnchor.constraint(equalTo: movieNameView.trailingAnchor, constant: -13.0),
            movieNameLabel.bottomAnchor.constraint(equalTo: movieNameView.bottomAnchor, constant: -8.0)
        ])
    }
}

private struct Metrics {
    static let movieNameSizeBase: CGFloat = 14.0
    static let movieNameSizeLarge: CGFloat = 26.0
    
    static let movieBlurPhone: CGFloat = 4.8
    static let movieBlurPad: CGFloat = 7.5
    
    init() {}
}

extension CarouselCell: MovieViewModelDelegate {
    func updateImage() {
        guard let viewModel else { return }
        
        if let image = viewModel.moviePoster {
            DispatchQueue.main.async {
                self.moviePoster.image = image
            }
        }
    }
    
    func updateLoadingState() {
        guard let viewModel else { return }
        
        DispatchQueue.main.async {
            if viewModel.isImageLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
