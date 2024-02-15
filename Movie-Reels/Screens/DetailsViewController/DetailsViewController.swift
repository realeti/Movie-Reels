//
//  DetailsViewController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    
    lazy var movieScrollView: UIScrollView = {
        let view = UIScrollView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    lazy var contentMovieView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var movieDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3.withAlphaComponent(0.3)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
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
    
    lazy var movieDescroptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: Metrics.movieDescriptionSize, weight: .semibold)
        return textView
    }()
    
    lazy var viewModel = DetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        viewModel.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupUI() {
        updateLoadingState()
        updateImage()
        
        movieNameLabel.text = viewModel.title
        movieDescroptionTextView.text = viewModel.overview
        updateMovieDate()
        
        view.addSubview(movieScrollView)
        movieScrollView.addSubview(contentMovieView)
        
        contentMovieView.addSubview(moviePoster)
        contentMovieView.addSubview(activityIndicator)
        contentMovieView.addSubview(movieDescriptionView)
        
        movieDescriptionView.addSubview(movieNameLabel)
        movieDescriptionView.addSubview(movieReleaseDateLabel)
        movieDescriptionView.addSubview(movieDescroptionTextView)
        
        movieScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentMovieView.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        movieDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        movieDescroptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            movieScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentMovieView.topAnchor.constraint(equalTo: movieScrollView.topAnchor),
            contentMovieView.leadingAnchor.constraint(equalTo: movieScrollView.leadingAnchor),
            contentMovieView.trailingAnchor.constraint(equalTo: movieScrollView.trailingAnchor),
            contentMovieView.bottomAnchor.constraint(equalTo: movieScrollView.bottomAnchor),
            contentMovieView.widthAnchor.constraint(equalTo: movieScrollView.widthAnchor),
            contentMovieView.heightAnchor.constraint(equalTo: movieScrollView.heightAnchor).withPriority(.defaultLow),
            
            moviePoster.topAnchor.constraint(equalTo: contentMovieView.topAnchor),
            moviePoster.leadingAnchor.constraint(equalTo: contentMovieView.leadingAnchor),
            moviePoster.trailingAnchor.constraint(equalTo: contentMovieView.trailingAnchor),
            moviePoster.heightAnchor.constraint(equalTo: moviePoster.widthAnchor, multiplier: 1.4),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentMovieView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentMovieView.centerYAnchor),
            
            movieDescriptionView.leadingAnchor.constraint(equalTo: contentMovieView.leadingAnchor, constant: Metrics.leadingIndent),
            movieDescriptionView.trailingAnchor.constraint(equalTo: contentMovieView.trailingAnchor, constant: -Metrics.traillingIndent),
            movieDescriptionView.topAnchor.constraint(equalTo: moviePoster.bottomAnchor, constant: Metrics.topIndent),
            movieDescriptionView.bottomAnchor.constraint(equalTo: contentMovieView.bottomAnchor, constant: -Metrics.bottomIndent),
            
            movieNameLabel.centerXAnchor.constraint(equalTo: movieDescriptionView.centerXAnchor),
            movieNameLabel.topAnchor.constraint(equalTo: movieDescriptionView.topAnchor, constant: Metrics.topIndent),
            
            movieReleaseDateLabel.centerXAnchor.constraint(equalTo: movieDescriptionView.centerXAnchor),
            movieReleaseDateLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor),
            
            movieDescroptionTextView.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: Metrics.topIndent * 2),
            movieDescroptionTextView.leadingAnchor.constraint(equalTo: movieDescriptionView.leadingAnchor, constant: Metrics.leadingIndent),
            movieDescroptionTextView.trailingAnchor.constraint(equalTo: movieDescriptionView.trailingAnchor, constant: -Metrics.traillingIndent),
            movieDescroptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: movieDescriptionView.bottomAnchor, constant: -Metrics.bottomIndent)
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
