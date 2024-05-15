//
//  ViewController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class MoviesViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(resource: .shadow)
        
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier)
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
        return collectionView
    }()

    private lazy var createCompositionalLayout: UICollectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
        let sectionIdentifier = self?.sectionTypes[sectionIndex]
        
        if sectionIdentifier == .playingNow {
            return self?.carouselSection.layoutSection()
        } else {
            return self?.createMoviesListSection()
        }
    }
    
    private lazy var carouselSection: CarouselSection = {
        CarouselSection(collectionView: collectionView)
    }()
    
    func createMoviesListSection() -> NSCollectionLayoutSection {
        let fractionWidth: CGFloat = 1.0 / 2.4
        let fractionHeight: CGFloat = fractionWidth * 1.45
        let itemInset: CGFloat = 4.0
        let sectionInset: CGFloat = 12.0
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalWidth(fractionHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.05))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        
        return section
    }
    
    let viewModel = MoviesCollectionViewModel()
    let sectionTypes: [SectionIdentifier] = [.playingNow, .trending, .popular]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        configureNavController()
        viewModel.loadMoviesData()
        setupUI()
    }
    
    private func configureNavController() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.backgroundColor = UIColor(resource: .shadow)
        
        collectionView.frame = view.bounds
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        collectionView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        let touchPoint = sender.location(in: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { return }
        
        let section = indexPath.section
        let sectionIdentifier = sectionTypes[section]
        
        guard let sectionForMovies = viewModel.moviesViewModels[sectionIdentifier] else {
            return
        }
        
        let currentMovie = sectionForMovies[indexPath.row]
        
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
        
        let section = indextPath.section
        let sectionIdentifier = sectionTypes[section]
        
        viewModel.configure(favorites: favoriteVC.viewModel, section: sectionIdentifier, for: indextPath)
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

extension MoviesViewController: MoviesCollectionViewModelDelegate {
    func updateNewMovies() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func updateMovies() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func updatePopularMovies() {
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionIdentifier = sectionTypes[section]
        
        guard let sectionForMovies = viewModel.moviesViewModels[sectionIdentifier] else {
            return 0
        }
        
        return sectionForMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var reuseIdentifier = ""
        
        if indexPath.section == 0 {
            reuseIdentifier = CarouselCell.reuseIdentifier
        } else {
            reuseIdentifier = MovieCollectionCell.reuseIdentifier
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BaseCollectionCell else {
            return UICollectionViewCell()
        }
        
        let section = indexPath.section
        let sectionIdentifier = sectionTypes[section]
        
        guard let sectionForMovies = viewModel.moviesViewModels[sectionIdentifier] else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = sectionForMovies[indexPath.row]
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier, for: indexPath) as? HeaderSupplementaryView else {
            return HeaderSupplementaryView()
        }
        
        let section = indexPath.section
        let sectionIdentifier = sectionTypes[section]
        
        headerView.titleLabel.text = sectionIdentifier.sectionTitle
        return headerView
    }
}

// MARK: - CollectionView delegate

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = indexPath.section
        let sectionIdentifier = sectionTypes[section]
        
        let detailVC = DetailsViewController()
        detailVC.hidesBottomBarWhenPushed = true
        viewModel.configure(details: detailVC.viewModel, section: sectionIdentifier, for: indexPath)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let sectionIdentifier = sectionTypes[section]
        
        guard let sectionForMovies = viewModel.moviesViewModels[sectionIdentifier],
              indexPath.row < sectionForMovies.count,
              let baseCell = cell as? BaseCollectionCell else
        { return }
        
        let cellViewModel = sectionForMovies[indexPath.row]
        cellViewModel.delegate = baseCell
        cellViewModel.loadImage()
        
        if let _ = baseCell as? CarouselCell {
            carouselSection.applyTransform(to: cell, at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.moviesViewModels.count else { return }
        
        let section = indexPath.section
        let sectionIdentifier = sectionTypes[section]
        
        guard let sectionForMovies = viewModel.moviesViewModels[sectionIdentifier] else {
            return
        }
        
        let cellViewModel = sectionForMovies[indexPath.row]
        
        cellViewModel.delegate = nil
    }
}
