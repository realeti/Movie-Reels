//
//  FavoritesViewController.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 200
        view.dataSource = self
        view.delegate = self
        view.register(MovieCell.self, forCellReuseIdentifier: Constants.movieCellIdentifier)
        return view
    }()
    
    let viewModel = FavoriteMovieTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.favoritesTabBarName
        view.backgroundColor = .systemBackground
        
        viewModel.delegate = self
        viewModel.loadMovies()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        title = Constants.favoritesTabBarName
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

// MARK: - ViewModel delegate

extension FavoritesViewController: FavoriteMovieTableViewModelDelegate {
    func updateMovies() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateError() {
        guard let error = viewModel.lastErrorMessage else { return }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
}

// MARK: - TableView data source

extension FavoritesViewController: UITableViewDataSource {
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

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: Constants.detailsStoryboardName, bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.detailsStoryboardName) as? DetailsViewController else {
            return
        }
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
