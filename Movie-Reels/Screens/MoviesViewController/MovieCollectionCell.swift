//
//  MovieCollectionCell.swift
//  Movie-Reels
//
//  Created by Apple M1 on 19.04.2024.
//

import UIKit
import VisualEffectView

enum DeviceType {
    case phone
    case pad
}

class MovieCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = Constants.movieCollectionCellIdentifier
    
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
    
    lazy var movieRatingStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = UIColor(resource: .jetLight).withAlphaComponent(0.95)
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 3
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    lazy var movieRatingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .starFilled).withTintColor(UIColor(resource: .sunny))
        return imageView
    }()
    
    lazy var movieRatingLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor(resource: .babyPowder)
        label.numberOfLines = 1
        return label
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
            updateMovieRating()
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
        let movieRatingCornerRadius: CGFloat
        
        switch device {
        case .phone:
            moviePosterCornerRadius = self.frame.width / 8
            movieRatingCornerRadius = self.frame.width / 20
        case .pad:
            moviePosterCornerRadius = self.frame.width / 10
            movieRatingCornerRadius = self.frame.width / 30
        }
        
        moviePosterView.layer.cornerRadius = moviePosterCornerRadius
        movieRatingStackView.layer.cornerRadius = movieRatingCornerRadius
        
        moviePosterView.clipsToBounds = true
        movieRatingStackView.clipsToBounds = true
    }
    
    private func updateSizes() {
        let defaultFontSize = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        let device: DeviceType = userDevice == .phone ? .phone : .pad
        
        let movieNameSize: CGFloat
        let movieRatingSize: CGFloat
        let movieRatingStackSpacing: CGFloat
        let movieRatingStackInsets: UIEdgeInsets
        let movieBlurRadius: CGFloat
        
        switch device {
        case .phone:
            movieNameSize = Metrics.movieNameSizeBase
            movieRatingSize = Metrics.movieRatingSizeBase
            movieRatingStackSpacing = 4
            movieRatingStackInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            movieBlurRadius = 4.8
        case .pad:
            movieNameSize = Metrics.movieNameSizeLarge
            movieRatingSize = Metrics.movieRatingSizeLarge
            movieRatingStackSpacing = 5
            movieRatingStackInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
            movieBlurRadius = 7.5
        }
        
        movieNameLabel.font = UIFont(name: Constants.movieTitleFont, size: movieNameSize) ?? defaultFontSize
        movieRatingLabel.font = UIFont(name: Constants.movieRatingFont, size: movieRatingSize) ?? defaultFontSize
        movieRatingStackView.spacing = movieRatingStackSpacing
        movieRatingStackView.layoutMargins = movieRatingStackInsets
        movieNameView.blurRadius = movieBlurRadius
    }
    
    private func setupUI() {
        contentView.addSubview(moviePosterView)
        moviePosterView.addSubview(moviePoster)
        moviePosterView.addSubview(activityIndicator)
        moviePosterView.addSubview(movieRatingStackView)
        movieRatingStackView.addArrangedSubview(movieRatingImage)
        movieRatingStackView.addArrangedSubview(movieRatingLabel)
        moviePosterView.addSubview(movieNameView)
        movieNameView.contentView.addSubview(movieNameLabel)
        
        contentView.backgroundColor = .clear
        userDevice = traitCollection.userInterfaceIdiom
        
        setupMoviePosterViewConstraints()
        setupMoviePosterConstraints()
        setupActivityIndicatorConstraints()
        setupMovieRatingStackConstraints()
        setupMovieRatingImageConstraints()
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
    
    private func setupMovieRatingStackConstraints() {
        movieRatingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let device: DeviceType = userDevice == .phone ? .phone : .pad
        let topIndent: CGFloat
        let rightIndent: CGFloat
        
        switch device {
        case .phone:
            topIndent = 10.0
            rightIndent = -6.0
        case .pad:
            topIndent = 16.0
            rightIndent = -10.0
        }
        
        NSLayoutConstraint.activate([
            movieRatingStackView.topAnchor.constraint(equalTo: moviePosterView.topAnchor, constant: topIndent),
            movieRatingStackView.rightAnchor.constraint(equalTo: moviePosterView.rightAnchor, constant: rightIndent)
        ])
    }
    
    private func setupMovieRatingImageConstraints() {
        movieRatingImage.translatesAutoresizingMaskIntoConstraints = false
        
        let device: DeviceType = userDevice == .phone ? .phone : .pad
        let imageSize: CGFloat
        
        switch device {
        case .phone:
            imageSize = Metrics.movieRatingImageSizeBase
        case .pad:
            imageSize = Metrics.movieRatingImageSizeLarge
        }
        
        NSLayoutConstraint.activate([
            movieRatingImage.heightAnchor.constraint(equalToConstant: imageSize),
            movieRatingImage.widthAnchor.constraint(equalToConstant: imageSize)
        ])
    }
    
    private func setupMovieNameViewConstraints() {
        movieNameView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNameView.leadingAnchor.constraint(equalTo: moviePosterView.leadingAnchor),
            movieNameView.trailingAnchor.constraint(equalTo: moviePosterView.trailingAnchor),
            movieNameView.bottomAnchor.constraint(equalTo: moviePosterView.bottomAnchor),
            movieNameView.heightAnchor.constraint(equalTo: moviePosterView.heightAnchor, multiplier: 0.27)
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

extension MovieCollectionCell: MovieViewModelDelegate {
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
    
    func updateMovieRating() {
        guard let viewModel else { return }
        
        self.movieRatingLabel.text = String(format: "%.1f", viewModel.voteAverage)
    }
}

private struct Metrics {
    static let movieNameSizeBase: CGFloat = 12.0
    static let movieNameSizeLarge: CGFloat = 24.0
    static let movieRatingSizeBase: CGFloat = 9.0
    static let movieRatingSizeLarge: CGFloat = 15.0
    
    static let movieRatingImageSizeBase: CGFloat = 9.0
    static let movieRatingImageSizeLarge: CGFloat = 15.0
    
    init() {}
}
