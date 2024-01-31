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
        
        self.view.backgroundColor = .systemBackground
        
        self.tableView.rowHeight = 200
        self.tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.movieCellIdentifier)
        
        self.viewModel.delegate = self
        self.viewModel.loadMovies()
    }
}

// MARK: - View model delegate

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

// MARK: - Table view data source

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

// MARK: - Table view delegate

extension MoviesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
}
