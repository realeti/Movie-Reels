//
//  MovieCollectionCell.swift
//  Movie-Reels
//
//  Created by Apple M1 on 19.04.2024.
//

import UIKit
import VisualEffectView

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
        view.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
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
        let bodyFont = UIFont(name: Constants.movieRatingFont, size: 9.0) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: bodyFont)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor(resource: .babyPowder)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var movieNameView: VisualEffectView = {
        let visualEffectView = VisualEffectView()
        visualEffectView.colorTint = UIColor(resource: .shadow)
        visualEffectView.colorTintAlpha = 0.5
        visualEffectView.blurRadius = 4.8
        return visualEffectView
    }()
    
    lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        let bodyFont = UIFont(name: Constants.movieTitleFont, size: Metrics.movieNameSizeBase) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: bodyFont)
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
        updateFontSize()
    }
    
    private func updateFontSize() {
        let defaultFontSize = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        
        if traitCollection.userInterfaceIdiom == .phone {
            let movieBaseTitle = UIFont(name: Constants.movieTitleFont, size: Metrics.movieNameSizeBase) ?? defaultFontSize
            let movieBaseRating = UIFont(name: Constants.movieRatingFont, size: Metrics.movieRatingSizeBase) ?? defaultFontSize

            movieNameLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: movieBaseTitle)
            movieRatingLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: movieBaseRating)
            
            movieRatingStackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        } else if traitCollection.userInterfaceIdiom == .pad {
            let movieLargeTitle = UIFont(name: Constants.movieTitleFont, size: Metrics.movieNameSizeLarge) ?? defaultFontSize
            let movieLargeRating = UIFont(name: Constants.movieRatingFont, size: Metrics.movieRatingSizeLarge) ?? defaultFontSize
            
            movieNameLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: movieLargeTitle)
            movieRatingLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: movieLargeRating)
            
            movieRatingStackView.layoutMargins = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        }
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
        
        contentView.backgroundColor = UIColor(resource: .lightNight)
        
        setupMoviePosterViewConstraints()
        setupMoviePosterConstraints()
        setupActivityIndicatorConstraints()
        setupMovieRatingStackConstraints()
        setupMovieRatingImageConstraints()
        setupMovieNameViewConstraints()
        setupMovieNameConstraints()
        
        contentView.layer.cornerRadius = self.frame.width / 8
        contentView.clipsToBounds = true
        
        moviePosterView.layer.cornerRadius = self.frame.width / 8
        moviePosterView.clipsToBounds = true
        
        movieRatingStackView.layer.cornerRadius = self.frame.width / 20
        movieRatingStackView.clipsToBounds = true
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
        
        NSLayoutConstraint.activate([
            movieRatingStackView.topAnchor.constraint(equalTo: moviePosterView.topAnchor, constant: 10.0),
            movieRatingStackView.rightAnchor.constraint(equalTo: moviePosterView.rightAnchor, constant: -6.0)
        ])
    }
    
    private func setupMovieRatingImageConstraints() {
        movieRatingImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieRatingImage.heightAnchor.constraint(equalToConstant: 10),
            movieRatingImage.widthAnchor.constraint(equalTo: movieRatingImage.heightAnchor)
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
    static let movieRatingSizeLarge: CGFloat = 14.0
    
    static let topIndent: CGFloat = 5.0
    static let leadingIndent: CGFloat = 8.0
    static let traillingIndent: CGFloat = 8.0
    static let bottomIndent: CGFloat = 5.0
    
    init() {}
}
