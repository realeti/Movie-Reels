//
//  MovieCell.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class MovieCell: UITableViewCell {

    static let reuseIdentifier = Constants.movieCellIdentifier
    
    lazy var movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: Metrics.movieReleaseDateSize, weight: .semibold)
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
        label.font = UIFont.systemFont(ofSize: Metrics.movieNameSize, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var movieGenresLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: Metrics.movieGenresSize, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var moviePosterView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
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
        contentView.addSubview(movieReleaseDateLabel)
        contentView.addSubview(movieInfoStackView)
        movieInfoStackView.addArrangedSubview(movieNameLabel)
        movieInfoStackView.addArrangedSubview(movieGenresLabel)
        contentView.addSubview(moviePosterView)
        
        moviePosterView.addSubview(moviePoster)
        moviePosterView.addSubview(activityIndicator)
        
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        movieInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        moviePosterView.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieReleaseDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.topIndent / 2),
            movieReleaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.leadingIndent),
            movieReleaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.traillingIndent),
            
            moviePosterView.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: Metrics.topIndent),
            moviePosterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.leadingIndent),
            moviePosterView.heightAnchor.constraint(equalToConstant: Metrics.moviePosterHeight),
            moviePosterView.widthAnchor.constraint(equalToConstant: Metrics.moviePosterWidth),
            moviePosterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.bottomIndent).withPriority(.defaultLow),
            
            movieInfoStackView.centerYAnchor.constraint(equalTo: moviePosterView.centerYAnchor, constant: -Metrics.topIndent),
            movieInfoStackView.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: Metrics.leadingIndent),
            movieInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.traillingIndent),
            
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
        movieGenresLabel.text = viewModel.genres.joined(separator: ", ")
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

private struct Metrics {
    static let movieReleaseDateSize: CGFloat = 16.0
    static let movieNameSize: CGFloat = 20.0
    static let movieGenresSize: CGFloat = 14.0
    
    static let topIndent: CGFloat = 8.0
    static let leadingIndent: CGFloat = 8.0
    static let traillingIndent: CGFloat = 8.0
    static let bottomIndent: CGFloat = 8.0
    
    static let moviePosterHeight: CGFloat = 120.0 // 150.0
    static let moviePosterWidth: CGFloat = 80.0 // 100.0
    
    init() {}
}

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
