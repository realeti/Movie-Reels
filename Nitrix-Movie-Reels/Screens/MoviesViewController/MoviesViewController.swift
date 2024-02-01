//
//  ViewController.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class MoviesViewController: UITableViewController {
    
    let viewModel = MoviesTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.moviesTabBarName
        view.backgroundColor = .systemBackground
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.movieCellIdentifier)
        
        viewModel.delegate = self
        viewModel.loadMovies()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        
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
                viewModel.storeFavoriteMovie(for: indexPath)
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
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
}

// MARK: - TableView data source

extension MoviesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviesViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieCellIdentifier) as? MovieCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.moviesViewModels[indexPath.row]
        cell.viewModel = cellViewModel
        
        return cell
    }
}

// MARK: - TableView delegate

extension MoviesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: Constants.detailsStoryboardName, bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.detailsStoryboardName) as? DetailsViewController else {
            return
        }
        
        viewModel.configure(details: detailVC.viewModel, for: indexPath)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.moviesViewModels.count,
              let cell = cell as? MovieCell else 
        { return }
        
        let cellViewModel = viewModel.moviesViewModels[indexPath.row]
        
        cellViewModel.delegate = cell
        cellViewModel.loadImage()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.moviesViewModels.count else { return }
        
        let cellViewModel = viewModel.moviesViewModels[indexPath.row]
        cellViewModel.delegate = nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
