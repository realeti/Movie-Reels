//
//  MovieTrailerViewController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 28.02.2024.
//

import UIKit
import YouTubeiOSPlayerHelper

class MovieTrailerViewController: UIViewController {
    
    lazy var movieTrailerView: YTPlayerView = {
        let view = YTPlayerView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMovieTrailerViewConstraints()
    }
    
    func setupUI() {
        view.addSubview(movieTrailerView)
    }
    
    func setupMovieTrailerViewConstraints() {
        movieTrailerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieTrailerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metrics.topIndent),
            movieTrailerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.leadingIndent),
            movieTrailerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.traillingIndent),
            movieTrailerView.heightAnchor.constraint(equalTo: movieTrailerView.widthAnchor, multiplier: 9.0 / 16.0)
        ])
    }
}

extension MovieTrailerViewController: MovieTrailerPresentable {
    func loadTrailer(key: String) {
        movieTrailerView.load(withVideoId: key)
    }
}

private struct Metrics {
    static let topIndent: CGFloat = 8.0
    static let leadingIndent: CGFloat = 8.0
    static let traillingIndent: CGFloat = 8.0
    static let bottomIndent: CGFloat = 8.0
    
    init() {}
}
