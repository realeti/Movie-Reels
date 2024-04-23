//
//  MovieCollectionCell.swift
//  Movie-Reels
//
//  Created by Apple M1 on 19.04.2024.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = Constants.movieCollectionCellIdentifier
    
    lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        let bodyFont = UIFont(name: Constants.movieTitleFont, size: Metrics.movieNameSizeBase) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: bodyFont)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor(resource: .babyPowder)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    lazy var moviePosterView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.tintColor = UIColor(resource: .darkOrange)
        return indicator
    }()
    
    var viewModel: MovieViewModel? {
        didSet {
            guard let viewModel else { return }
            
            movieNameLabel.text = viewModel.title
            updateImage()
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
        if traitCollection.userInterfaceIdiom == .pad {
            let bodyFont = UIFont(name: Constants.movieTitleFont, size: Metrics.movieNameSizeLarge) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
            movieNameLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: bodyFont)
        } else if traitCollection.userInterfaceIdiom == .phone {
            let bodyFont = UIFont(name: Constants.movieTitleFont, size: Metrics.movieNameSizeBase) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
            movieNameLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: bodyFont)
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(resource: .lightNight)
        
        contentView.layer.cornerRadius = self.frame.width / 8
        contentView.clipsToBounds = true
        
        moviePosterView.layer.cornerRadius = self.frame.width / 8
        moviePosterView.clipsToBounds = true
        
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(moviePosterView)
        moviePosterView.addSubview(moviePoster)
        moviePosterView.addSubview(activityIndicator)
        
        setupMovieNameConstraints()
        setupMoviePosterViewConstraints()
        setupMoviePosterConstraints()
        setupActivityIndicatorConstraints()
    }
    
    private func setupMovieNameConstraints() {
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.leadingIndent),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.traillingIndent),
            movieNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.bottomIndent)
        ])
    }
    
    private func setupMoviePosterViewConstraints() {
        moviePosterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moviePosterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            moviePosterView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            moviePosterView.bottomAnchor.constraint(equalTo: movieNameLabel.topAnchor, constant: -Metrics.bottomIndent)
        ])
    }
    
    private func setupMoviePosterConstraints() {
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: moviePosterView.topAnchor),
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
}

extension MovieCollectionCell: MovieViewModelDelegate {
    func updateMovieDate() {
        //
    }
    
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

private struct Metrics {
    static let movieNameSizeBase: CGFloat = 14.0
    static let movieNameSizeLarge: CGFloat = 24.0
    
    static let topIndent: CGFloat = 5.0
    static let leadingIndent: CGFloat = 8.0
    static let traillingIndent: CGFloat = 8.0
    static let bottomIndent: CGFloat = 5.0
    
    init() {}
}
