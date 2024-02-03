//
//  TabController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
    }
    
    // MARK: - Tab Bar Setup
    
    private func setupTabs() {
        
        let moviesVC = MoviesViewController()
        let favoritesVC = FavoritesViewController()

        let movies = self.createNavTabBarItem(with: Constants.moviesTabBarName, and: UIImage(systemName: "movieclapper.fill"), vc: moviesVC)
        let favorites = self.createNavTabBarItem(with: Constants.favoritesTabBarName, and: UIImage(systemName: "star.fill"), vc: favoritesVC)
        
        self.setViewControllers([movies, favorites], animated: true)
    }
    
    private func createNavTabBarItem(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let item = UINavigationController(rootViewController: vc)
        
        item.tabBarItem.title = title
        item.tabBarItem.image = image
        item.viewControllers.first?.navigationItem.title = title
        
        return item
    }
}
