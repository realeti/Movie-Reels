//
//  ViewController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class MoviesViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(resource: .night)
        tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.movieCellIdentifier)
        return tableView
    }()
    
    let viewModel = MoviesTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        configureNavController()
        viewModel.loadMoviesData()
        setupUI()
    }
    
    func configureNavController() {
        title = Constants.moviesTabBarName
        
        let titleColor = UIColor(resource: .babyPowder)
        let attributedText = [NSAttributedString.Key.foregroundColor : titleColor]
        navigationController?.navigationBar.titleTextAttributes = attributedText
        navigationController?.navigationBar.barTintColor = UIColor(resource: .night)
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupTapGesture()
    }
    
    func setupTapGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let currentMovie = viewModel.moviesViewModels[indexPath.row]
                
                let alert = UIAlertController(title: currentMovie.title, message: Constants.addMovieToFavorites, preferredStyle: .alert)
                
                let actionDone = UIAlertAction(title: Constants.alertActionYes, style: .default) { _ in
                    guard let tabBarController = self.tabBarController else {
                        return
                    }
                    
                    guard let favoriteNavVC = tabBarController.viewControllers?[1] as? UINavigationController else {
                        return
                    }
                    
                    guard let favoriteVC = favoriteNavVC.viewControllers.first as? FavoritesViewController else {
                        return
                    }
                    
                    self.viewModel.configure(favorites: favoriteVC.viewModel, for: indexPath)
                }
                
                let actionCancel = UIAlertAction(title: Constants.alertActionCancel, style: .cancel)
                
                alert.addAction(actionDone)
                alert.addAction(actionCancel)
                
                self.present(alert, animated: true)
            }
        }
    }
}

// MARK: - ViewModel delegate

extension MoviesViewController: MoviesTableViewModelDelegate {
    func updateMovies() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateError() {
        guard let error = viewModel.lastErrorMessage else { return }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Constants.alertError, message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.alertActionOk, style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
}

// MARK: - TableView data source

extension MoviesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviesViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieCellIdentifier) as? MovieCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.moviesViewModels[indexPath.row]
        cell.viewModel = cellViewModel
        
        return cell
    }
}

// MARK: - TableView delegate

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = DetailsViewController()
        detailVC.hidesBottomBarWhenPushed = true
        viewModel.configure(details: detailVC.viewModel, for: indexPath)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.moviesViewModels.count,
              let cell = cell as? MovieCell else 
        { return }
        
        let cellViewModel = viewModel.moviesViewModels[indexPath.row]
        
        cellViewModel.delegate = cell
        cellViewModel.loadImage()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.moviesViewModels.count else { return }
        
        let cellViewModel = viewModel.moviesViewModels[indexPath.row]
        cellViewModel.delegate = nil
    }
}
