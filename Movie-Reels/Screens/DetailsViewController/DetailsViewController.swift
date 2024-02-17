//
//  DetailsViewController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 31.01.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let buttonImage = UIImage(named: Constants.backButtonName)?.withTintColor(UIColor(resource: .babyPowder))
        button.setImage(buttonImage, for: .normal)
        button.backgroundColor = UIColor(resource: .jet)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        let action = UIAction { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    lazy var movieScrollView: UIScrollView = {
        let view = UIScrollView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor(resource: .night)
        return view
    }()
    
    lazy var contentMovieView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .night)
        return view
    }()
    
    lazy var movieDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .lightNight)
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
        label.textColor = UIColor(resource: .babyPowder)
        label.textAlignment = .center
        label.font = UIFont(name: Constants.movieTitleFont, size: Metrics.movieNameSize)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .cadetGray)
        label.font = UIFont(name: Constants.movieMainTextFont, size: Metrics.movieReleaseDateSize)
        return label
    }()
    
    lazy var movieDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textColor = UIColor(resource: .cadetGray)
        textView.font = UIFont(name: Constants.movieMainTextFont, size: Metrics.movieDescriptionSize)
        return textView
    }()
    
    lazy var viewModel = DetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        configureNavController()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func configureNavController() {
        navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            self.movieScrollView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
    }
    
    func setupUI() {
        updateLoadingState()
        updateImage()
        
        movieNameLabel.text = viewModel.title
        movieDescriptionTextView.text = viewModel.overview
        updateMovieDate()
        
        view.addSubview(movieScrollView)
        view.addSubview(backButton)
        movieScrollView.addSubview(contentMovieView)
        
        contentMovieView.addSubview(moviePoster)
        contentMovieView.addSubview(activityIndicator)
        contentMovieView.addSubview(movieDescriptionView)
        
        movieDescriptionView.addSubview(movieNameLabel)
        movieDescriptionView.addSubview(movieReleaseDateLabel)
        movieDescriptionView.addSubview(movieDescriptionTextView)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        movieScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentMovieView.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        movieDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        movieDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metrics.topIndent),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.leadingIndent * 2),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
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
            
            movieDescriptionView.topAnchor.constraint(equalTo: moviePoster.bottomAnchor, constant: Metrics.topIndent * 6),
            movieDescriptionView.leadingAnchor.constraint(equalTo: contentMovieView.leadingAnchor),
            movieDescriptionView.trailingAnchor.constraint(equalTo: contentMovieView.trailingAnchor),
            movieDescriptionView.bottomAnchor.constraint(equalTo: contentMovieView.bottomAnchor, constant: -Metrics.bottomIndent),
            
            movieNameLabel.topAnchor.constraint(equalTo: movieDescriptionView.topAnchor, constant: Metrics.topIndent * 2),
            movieNameLabel.leadingAnchor.constraint(equalTo: movieDescriptionView.leadingAnchor, constant: Metrics.leadingIndent),
            movieNameLabel.trailingAnchor.constraint(equalTo: movieDescriptionView.trailingAnchor, constant: -Metrics.traillingIndent),
            
            movieReleaseDateLabel.centerXAnchor.constraint(equalTo: movieDescriptionView.centerXAnchor),
            movieReleaseDateLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: Metrics.topIndent),
            
            movieDescriptionTextView.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: Metrics.topIndent * 4),
            movieDescriptionTextView.leadingAnchor.constraint(equalTo: movieDescriptionView.leadingAnchor, constant: Metrics.leadingIndent),
            movieDescriptionTextView.trailingAnchor.constraint(equalTo: movieDescriptionView.trailingAnchor, constant: -Metrics.traillingIndent),
            movieDescriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: movieDescriptionView.bottomAnchor, constant: -Metrics.bottomIndent)
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
    static let movieReleaseDateSize: CGFloat = 16.0
    static let movieDescriptionSize: CGFloat = 15.0
    
    static let topIndent: CGFloat = 8.0
    static let leadingIndent: CGFloat = 8.0
    static let traillingIndent: CGFloat = 8.0
    static let bottomIndent: CGFloat = 8.0
    
    init() {}
}
