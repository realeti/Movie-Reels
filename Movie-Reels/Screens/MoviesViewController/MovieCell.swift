//
//  MovieCell.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class MovieCell: UITableViewCell {

    static let reuseIdentifier = Constants.movieCellIdentifier
    
    lazy var movieCellView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: .zero, height: 180)
        view.backgroundColor = UIColor(resource: .lightNight)
        view.layer.cornerRadius = 14
        return view
    }()
    
    lazy var movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .cadetGray)
        label.font = UIFont(name: Constants.movieMainTextFont, size: Metrics.movieReleaseDateSize)
        return label
    }()
    
    lazy var movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3.0
        return stackView
    }()
    
    lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.movieTitleFont, size: Metrics.movieNameSize)
        label.textColor = UIColor(resource: .babyPowder)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var movieGenresLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .cadetGray)
        label.font = UIFont(name: Constants.movieMainTextFont, size: Metrics.movieGenresSize)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var moviePosterView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    
    lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    var viewModel: MovieViewModel? {
        didSet {
            guard let viewModel else { return }
            movieNameLabel.text = viewModel.title
            updateGenres()
            updateMovieDate()
            updateImage()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(resource: .night)
        
        contentView.addSubview(movieCellView)
        movieCellView.addSubview(movieReleaseDateLabel)
        movieCellView.addSubview(movieInfoStackView)
        movieInfoStackView.addArrangedSubview(movieNameLabel)
        movieInfoStackView.addArrangedSubview(movieGenresLabel)
        movieCellView.addSubview(moviePosterView)
        
        moviePosterView.addSubview(moviePoster)
        moviePosterView.addSubview(activityIndicator)
        
        movieCellView.translatesAutoresizingMaskIntoConstraints = false
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        movieInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        moviePosterView.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            movieCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.leadingIndent * 2),
            movieCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.traillingIndent * 2),
            movieCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            movieReleaseDateLabel.topAnchor.constraint(equalTo: movieCellView.topAnchor, constant: Metrics.topIndent / 2),
            movieReleaseDateLabel.leadingAnchor.constraint(equalTo: movieCellView.leadingAnchor, constant: Metrics.leadingIndent),
            movieReleaseDateLabel.trailingAnchor.constraint(equalTo: movieCellView.trailingAnchor, constant: -Metrics.traillingIndent),
            
            moviePosterView.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: Metrics.topIndent),
            moviePosterView.leadingAnchor.constraint(equalTo: movieCellView.leadingAnchor, constant: Metrics.leadingIndent),
            moviePosterView.heightAnchor.constraint(equalToConstant: Metrics.moviePosterHeight),
            moviePosterView.widthAnchor.constraint(equalToConstant: Metrics.moviePosterWidth),
            moviePosterView.bottomAnchor.constraint(equalTo: movieCellView.bottomAnchor, constant: -Metrics.bottomIndent).withPriority(.defaultLow),
            
            movieInfoStackView.centerYAnchor.constraint(equalTo: moviePosterView.centerYAnchor, constant: -Metrics.topIndent),
            movieInfoStackView.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: Metrics.leadingIndent),
            movieInfoStackView.trailingAnchor.constraint(equalTo: movieCellView.trailingAnchor, constant: -Metrics.traillingIndent),
            
            moviePoster.topAnchor.constraint(equalTo: moviePosterView.topAnchor),
            moviePoster.leadingAnchor.constraint(equalTo: moviePosterView.leadingAnchor),
            moviePoster.trailingAnchor.constraint(equalTo: moviePosterView.trailingAnchor),
            moviePoster.bottomAnchor.constraint(equalTo: moviePosterView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: moviePosterView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: moviePosterView.centerYAnchor)
        ])
    }
}

extension MovieCell: MovieViewModelDelegate {
    func updateGenres() {
        guard let viewModel else { return }
        movieGenresLabel.text = viewModel.genres.joined(separator: " • ")
    }
    
    func updateMovieDate() {
        guard let viewModel else { return }
        
        guard let relaseDate = DateFormatter.formattedString (
            from: viewModel.releaseDate,
            inputFormat: "yyyy-MM-dd",
            outputFormat: "MMMM yyyy"
        ) else {
            return
        }
        
        movieReleaseDateLabel.text = relaseDate
    }
    
    func updateImage() {
        guard let viewModel else { return }
        
        if let data = viewModel.posterData, let image = UIImage(data: data) {
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

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

private struct Metrics {
    static let movieReleaseDateSize: CGFloat = 16.0
    static let movieNameSize: CGFloat = 20.0
    static let movieGenresSize: CGFloat = 15.0
    
    static let topIndent: CGFloat = 8.0
    static let leadingIndent: CGFloat = 8.0
    static let traillingIndent: CGFloat = 8.0
    static let bottomIndent: CGFloat = 8.0
    
    static let moviePosterHeight: CGFloat = 135.0
    static let moviePosterWidth: CGFloat = 90.0
    
    init() {}
}
