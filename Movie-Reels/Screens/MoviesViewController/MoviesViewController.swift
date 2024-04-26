//
//  ViewController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class MoviesViewController: UIViewController {
    
    let itemsPerRow: CGFloat = 3
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(resource: .shadow)
        
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
        return collectionView
    }()
    
    let viewModel = MoviesTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        configureNavController()
        viewModel.loadMoviesData()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLayout()
    }
    
    private func updateLayout() {
        collectionView.frame = view.bounds
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let sectionInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let minimumInteritemSpacing = flowLayout.minimumInteritemSpacing * (itemsPerRow - 1)
        let totalWidth = collectionView.bounds.width
        let availableWidth = totalWidth - sectionInsets - minimumInteritemSpacing
        let widthPerItem = availableWidth / itemsPerRow
        
        flowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem * 1.5)
        flowLayout.invalidateLayout()
    }
    
    private func configureNavController() {
        title = Constants.moviesTabBarName
        
        let titleColor = UIColor(resource: .babyPowder)
        let attributedText = [NSAttributedString.Key.foregroundColor : titleColor]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = attributedText
        appearance.backgroundColor = UIColor(resource: .shadow)
        appearance.backgroundEffect = .none
        
        navigationController?.navigationBar.standardAppearance = appearance
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        
        collectionView.frame = view.bounds
        setupTapGesture()
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 15
        
        return flowLayout
    }
    
    private func setupTapGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        collectionView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        let touchPoint = sender.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { return }
        let currentMovie = viewModel.moviesViewModels[indexPath.row]
        
        presentMovieAlert(for: currentMovie, at: indexPath)
    }
    
    private func presentMovieAlert(for movie: MovieViewModel, at indextPath: IndexPath) {
        let alert = CreateAlertController(for: movie)
        let actionDone = UIAlertAction(title: Constants.alertActionYes, style: .default) { [weak self] _ in
            self?.addMovieToFavorites(from: indextPath)
        }
        let actionCancel = UIAlertAction(title: Constants.alertActionCancel, style: .cancel)
        
        alert.addAction(actionDone)
        alert.addAction(actionCancel)
        
        present(alert, animated: true)
    }
    
    private func CreateAlertController(for movie: MovieViewModel) -> UIAlertController {
        return UIAlertController(title: movie.title, message: Constants.addMovieToFavorites, preferredStyle: .alert)
    }
    
    private func addMovieToFavorites(from indextPath: IndexPath) {
        guard let favoriteVC = getFavoritesViewController() else { return }
        viewModel.configure(favorites: favoriteVC.viewModel, for: indextPath)
    }
    
    private func getFavoritesViewController() -> FavoritesViewController? {
        guard let tabBarController = self.tabBarController,
              let favoriteNavVC = tabBarController.viewControllers?[2] as? UINavigationController,
              let favoriteVC = favoriteNavVC.viewControllers.first as? FavoritesViewController else {
            return nil
        }
        return favoriteVC
    }
}

// MARK: - ViewModel delegate

extension MoviesViewController: MoviesTableViewModelDelegate {
    func updateMovies() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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

// MARK: - CollectionView data source

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = viewModel.moviesViewModels[indexPath.row]
        cell.viewModel = cellViewModel
        
        return cell
    }
}

// MARK: - CollectionView delegate

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let detailVC = DetailsViewController()
        detailVC.hidesBottomBarWhenPushed = true
        viewModel.configure(details: detailVC.viewModel, for: indexPath)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.moviesViewModels.count,
              let cell = cell as? MovieCollectionCell else
        { return }
        
        let cellViewModel = viewModel.moviesViewModels[indexPath.row]
        
        cellViewModel.delegate = cell
        cellViewModel.loadImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.moviesViewModels.count else { return }
        
        let cellViewModel = viewModel.moviesViewModels[indexPath.row]
        cellViewModel.delegate = nil
    }
}
