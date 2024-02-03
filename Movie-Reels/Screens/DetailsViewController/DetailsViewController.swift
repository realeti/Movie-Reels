//
//  DetailsViewController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    
    lazy var movieDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3.withAlphaComponent(0.3)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var moviePosterView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = .systemRed
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
    
    lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Metrics.movieNameSize, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: Metrics.movieReleaseDateSize, weight: .semibold)
        return label
    }()
    
    lazy var movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Metrics.movieDescriptionSize, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var viewModel = DetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = viewModel.title
        
        viewModel.delegate = self
        setupUI()
    }
    
    func setupUI() {
        updateLoadingState()
        updateImage()
        
        movieNameLabel.text = viewModel.title
        movieDescriptionLabel.text = viewModel.overview
        updateMovieDate()
        
        view.addSubview(movieDescriptionView)
        view.addSubview(moviePosterView)
        moviePosterView.addSubview(moviePoster)
        moviePosterView.addSubview(activityIndicator)
        movieDescriptionView.addSubview(movieNameLabel)
        movieDescriptionView.addSubview(movieReleaseDateLabel)
        movieDescriptionView.addSubview(movieDescriptionLabel)
        
        movieDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        moviePosterView.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieDescriptionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Metrics.bottomIndent),
            movieDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.leadingIndent),
            movieDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.traillingIndent),
            movieDescriptionView.heightAnchor.constraint(equalTo: moviePosterView.heightAnchor, multiplier: 0.35),
            
            moviePosterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metrics.topIndent),
            moviePosterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moviePosterView.bottomAnchor.constraint(equalTo: movieDescriptionView.topAnchor, constant: -Metrics.bottomIndent),
            moviePosterView.widthAnchor.constraint(equalTo: movieDescriptionView.widthAnchor),
            
            moviePoster.topAnchor.constraint(equalTo: moviePosterView.topAnchor),
            moviePoster.leadingAnchor.constraint(equalTo: moviePosterView.leadingAnchor),
            moviePoster.trailingAnchor.constraint(equalTo: moviePosterView.trailingAnchor),
            moviePoster.bottomAnchor.constraint(equalTo: moviePosterView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: moviePosterView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: moviePosterView.centerYAnchor),
            
            movieNameLabel.centerXAnchor.constraint(equalTo: movieDescriptionView.centerXAnchor),
            movieNameLabel.topAnchor.constraint(equalTo: movieDescriptionView.topAnchor, constant: Metrics.topIndent),
            
            movieReleaseDateLabel.centerXAnchor.constraint(equalTo: movieDescriptionView.centerXAnchor),
            movieReleaseDateLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor),
            
            movieDescriptionLabel.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: Metrics.topIndent * 2),
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: movieDescriptionView.leadingAnchor, constant: Metrics.leadingIndent),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: movieDescriptionView.trailingAnchor, constant: -Metrics.traillingIndent),
            movieDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: movieDescriptionView.bottomAnchor, constant: -Metrics.bottomIndent)
        ])
    }
    
    func updateMovieDate() {
        guard let relaseDate = DateFormatter.formattedString (
            from: viewModel.releaseDate,
            inputFormat: "yyyy-MM-dd",
            outputFormat: "MMMM yyyy"
        ) else {
            return
        }
        
        movieReleaseDateLabel.text = relaseDate
    }
}

// MARK: - Details ViewModel delegate

extension DetailsViewController: DetailsViewModelDelegate {
    func updateImage() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.updateImage()
            }
            return
        }
        
        if let data = viewModel.imageData, let image = UIImage(data: data) {
            moviePoster.image = image
        } else {
            moviePoster.image = nil
        }
    }
    
    func updateError() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.updateError()
            }
            return
        }
        
        guard let error = viewModel.lastErrorMessage else { return }
        let alert = UIAlertController(title: Constants.alertError, message: error, preferredStyle: .actionSheet)
        alert.addAction(.init(title: Constants.alertActionOk, style: .cancel))
        
        present(alert, animated: true)
    }
    
    func updateLoadingState() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.updateLoadingState()
            }
            return
        }
        
        if viewModel.isImageLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

private struct Metrics {
    static let movieNameSize: CGFloat = 24.0
    static let movieReleaseDateSize: CGFloat = 13.0
    static let movieDescriptionSize: CGFloat = 14.0
    
    static let topIndent: CGFloat = 8.0
    static let leadingIndent: CGFloat = 8.0
    static let traillingIndent: CGFloat = 8.0
    static let bottomIndent: CGFloat = 8.0
    
    init() {}
}
