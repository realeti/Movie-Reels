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
        let backButtonImage = UIImage(named: Constants.backButtonName)
        let coloredBackButton = backButtonImage?.withTintColor(.white)
        button.setImage(coloredBackButton, for: .normal)
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
        view.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
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
        let imageView = GradientImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addGradient(colorStyle: .nightTransition, direction: .bottom)
        return imageView
    }()
    
    lazy var posterButtonsStackView: UIStackView = {
       let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 8
        view.alignment = .center
        return view
    }()
    
    lazy var playButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        let image = UIImage(systemName: Constants.playButtonImage)
        
        container.font = UIFont(name: Constants.playButtonFont, size: Metrics.playButtonTitleSize)
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: Metrics.playButtonImageSize)
        configuration.image = image
        configuration.imagePadding = 15
        configuration.attributedTitle = AttributedString(Constants.playButtonTitle, attributes: container)
        
        let button = GradientButton(configuration: configuration)
        button.frame.size = CGSize(width: Metrics.playButtonWidth, height: Metrics.playButtonHeight)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 162.0, green: 52.0, blue: 23.0).cgColor
        button.addGradient(colorStyle: .darkOrange, direction: .left)
        
        let action = UIAction { _ in
            guard let randomTrailer = self.viewModel.movieTrailersKeys?.randomElement() else { return }
            
            let movieTrailerVC = MovieTrailerViewController()
            self.viewModel.configure(trailer: movieTrailerVC, key: randomTrailer)
            
            movieTrailerVC.modalPresentationStyle = .pageSheet
            
            if let sheet = movieTrailerVC.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            
            self.present(movieTrailerVC, animated: true)
        }
        
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: Metrics.bookMarkButtonWidth, height: Metrics.bookMarkButtonHeight)
        button.backgroundColor = UIColor(resource: .lightNight)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        
        let image = UIImage(resource: .bookmark2).withTintColor(UIColor(resource: .cadetGray))
        button.setImage(image, for: .normal)
        
        let action = UIAction { _ in
            print("Press Bookmark button")
        }
        
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.tintColor = UIColor(resource: .darkOrange)
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
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }*/
    
    private func configureNavController() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            self.movieScrollView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
    }
    
    func setupUI() {
        updateLoadingState()
        updateImage()
        updateMovieDate()
        
        view.addSubview(movieScrollView)
        view.addSubview(backButton)
        movieScrollView.addSubview(contentMovieView)
        
        contentMovieView.addSubview(moviePoster)
        contentMovieView.addSubview(activityIndicator)
        
        contentMovieView.addSubview(posterButtonsStackView)
        posterButtonsStackView.addArrangedSubview(playButton)
        posterButtonsStackView.addArrangedSubview(bookmarkButton)
        
        contentMovieView.addSubview(movieDescriptionView)
        movieDescriptionView.addSubview(movieNameLabel)
        movieDescriptionView.addSubview(movieReleaseDateLabel)
        movieDescriptionView.addSubview(movieDescriptionTextView)
        
        setupMovieScrollConstraints()
        setupBackButtonConstraints()
        setupContentMovieConstraints()
        setupMoviePosterConstraints()
        setupActivityIndicatorConstraints()
        setupPosterButtonsStackConstraints()
        setupPlayButtonConstraints()
        setupBookmarkButtonConstraints()
        setupMovieDescriptionViewConstraints()
        setupMovieNameConstraints()
        setupMovieReleaseDateConstraints()
        setupMovieDescriptionTextConstraints()
        
        movieNameLabel.text = viewModel.title
        movieDescriptionTextView.text = viewModel.overview
    }
    
    // MARK: - Setup Constraints
    
    func setupMovieScrollConstraints() {
        movieScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            movieScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBackButtonConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metrics.topIndent),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.leadingIndent * 2),
            backButton.widthAnchor.constraint(equalToConstant: Metrics.backButtonWidth),
            backButton.heightAnchor.constraint(equalToConstant: Metrics.backButtonHeight)
        ])
    }
    
    func setupContentMovieConstraints() {
        contentMovieView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentMovieView.topAnchor.constraint(equalTo: movieScrollView.topAnchor),
            contentMovieView.leadingAnchor.constraint(equalTo: movieScrollView.leadingAnchor),
            contentMovieView.trailingAnchor.constraint(equalTo: movieScrollView.trailingAnchor),
            contentMovieView.bottomAnchor.constraint(equalTo: movieScrollView.bottomAnchor),
            contentMovieView.widthAnchor.constraint(equalTo: movieScrollView.widthAnchor),
            contentMovieView.heightAnchor.constraint(equalTo: movieScrollView.heightAnchor).withPriority(.defaultLow)
        ])
    }
    
    func setupMoviePosterConstraints() {
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: contentMovieView.topAnchor),
            moviePoster.widthAnchor.constraint(equalTo: contentMovieView.widthAnchor),
            moviePoster.heightAnchor.constraint(equalTo: moviePoster.widthAnchor, multiplier: 1.4)
        ])
    }
    
    func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: moviePoster.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: moviePoster.centerYAnchor)
        ])
    }
    
    func setupPosterButtonsStackConstraints() {
        posterButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterButtonsStackView.topAnchor.constraint(equalTo: moviePoster.bottomAnchor, constant: Metrics.topIndent),
            posterButtonsStackView.leadingAnchor.constraint(equalTo: contentMovieView.leadingAnchor, constant: Metrics.leadingIndent * 2),
            posterButtonsStackView.trailingAnchor.constraint(equalTo: contentMovieView.trailingAnchor, constant: -Metrics.traillingIndent * 2)
        ])
    }
    
    func setupPlayButtonConstraints() {
        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(equalToConstant: Metrics.playButtonWidth).withPriority(.defaultLow),
            playButton.heightAnchor.constraint(equalToConstant: Metrics.playButtonHeight)
        ])
    }
    
    func setupBookmarkButtonConstraints() {
        NSLayoutConstraint.activate([
            bookmarkButton.widthAnchor.constraint(equalToConstant: Metrics.bookMarkButtonWidth),
            bookmarkButton.heightAnchor.constraint(equalToConstant: Metrics.bookMarkButtonHeight)
        ])
    }
    
    func setupMovieDescriptionViewConstraints() {
        movieDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieDescriptionView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: Metrics.topIndent * 5),
            movieDescriptionView.leadingAnchor.constraint(equalTo: contentMovieView.leadingAnchor),
            movieDescriptionView.trailingAnchor.constraint(equalTo: contentMovieView.trailingAnchor),
            movieDescriptionView.bottomAnchor.constraint(equalTo: contentMovieView.bottomAnchor, constant: -Metrics.bottomIndent)
        ])
    }
    
    func setupMovieNameConstraints() {
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: movieDescriptionView.topAnchor, constant: Metrics.topIndent * 2),
            movieNameLabel.leadingAnchor.constraint(equalTo: movieDescriptionView.leadingAnchor, constant: Metrics.leadingIndent),
            movieNameLabel.trailingAnchor.constraint(equalTo: movieDescriptionView.trailingAnchor, constant: -Metrics.traillingIndent)
        ])
    }
    
    func setupMovieReleaseDateConstraints() {
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieReleaseDateLabel.centerXAnchor.constraint(equalTo: movieDescriptionView.centerXAnchor),
            movieReleaseDateLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: Metrics.topIndent)
        ])
    }
    
    func setupMovieDescriptionTextConstraints() {
        movieDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieDescriptionTextView.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: Metrics.topIndent * 4),
            movieDescriptionTextView.leadingAnchor.constraint(equalTo: movieDescriptionView.leadingAnchor, constant: Metrics.leadingIndent),
            movieDescriptionTextView.trailingAnchor.constraint(equalTo: movieDescriptionView.trailingAnchor, constant: -Metrics.traillingIndent),
            movieDescriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: movieDescriptionView.bottomAnchor, constant: -Metrics.bottomIndent)
        ])
    }
}

// MARK: - Details ViewModel delegate

extension DetailsViewController: DetailsViewModelDelegate {
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
}

private struct Metrics {
    static let backButtonWidth: CGFloat = 44.0
    static let backButtonHeight: CGFloat = 44.0
    
    static let movieNameSize: CGFloat = 24.0
    static let movieReleaseDateSize: CGFloat = 16.0
    static let movieDescriptionSize: CGFloat = 15.0
    
    static let playButtonWidth: CGFloat = 150.0
    static let playButtonHeight: CGFloat = 50.0
    static let playButtonTitleSize: CGFloat = 22.0
    static let playButtonImageSize: CGFloat = 16.0
    
    static let bookMarkButtonWidth: CGFloat = 50.0
    static let bookMarkButtonHeight: CGFloat = 50.0
    
    static let topIndent: CGFloat = 8.0
    static let leadingIndent: CGFloat = 8.0
    static let traillingIndent: CGFloat = 8.0
    static let bottomIndent: CGFloat = 8.0
    
    init() {}
}
