//
//  ViewController.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class MoviesViewController: UITableViewController {
    
    let networkController = NetworkController()
    var movieList: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.movieCellIdentifier)
        
        loadNetworkData()
    }
    
    func loadNetworkData() {
        networkController.fetchMovies { [weak self] result in
            do {
                let movies = try result.get()
                self?.movieList = movies
            } catch {
                self?.movieList = []
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - Table view data source

extension MoviesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count == 0 ? 1 : movieList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieCellIdentifier) as? MovieCell else {
            return UITableViewCell()
        }
        
        if movieList.count == 0 {
            cell.movieNameLabel.text = Constants.movieNotLoaded
        } else {
            let movie = movieList[indexPath.row].title
            //let overview = movieList[indexPath.row].overview
            
            cell.movieNameLabel.text = movie
        }
        
        return cell
    }
}

// MARK: - Table view delegate

extension MoviesViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.movieListName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
