//
//  FavoritesViewController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

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
    
    let viewModel = FavoriteMovieTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        configureNavController()
        viewModel.loadMoviesData()
        setupUI()
    }
    
    private func configureNavController() {
        title = Constants.favoritesTabBarName
        let titleColor = UIColor(resource: .babyPowder)
        let attributedText = [NSAttributedString.Key.foregroundColor : titleColor]
        navigationController?.navigationBar.titleTextAttributes = attributedText
        navigationController?.navigationBar.barTintColor = UIColor(resource: .night)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
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
            let alert = UIAlertController(title: Constants.alertError, message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.alertActionOk, style: .cancel))
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionDeleteInstance = UIContextualAction(style: .destructive, title: Constants.removeFavoriteMovie) { [self] _,_,_ in
            viewModel.removeFavoriteMovie(for: indexPath)
            
            if viewModel.moviesViewModels.count > 0 {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                tableView.reloadData()
            }
        }
        
        return UISwipeActionsConfiguration(actions: [actionDeleteInstance])
    }
}
