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
        
        tabBar.barTintColor = UIColor(resource: .lightNight)
        tabBar.backgroundColor = UIColor(resource: .lightNight)
        tabBar.tintColor = UIColor(resource: .orange)
        tabBar.unselectedItemTintColor = UIColor(resource: .babyPowder)
        self.setupTabs()
    }
    
    // MARK: - Tab Bar Setup
    
    private func setupTabs() {
        
        let moviesVC = MoviesViewController()
        let favoritesVC = FavoritesViewController()
        //let catalogVC = CatalogViewController()

        let movies = self.createNavTabBarItem(with: Constants.moviesTabBarName, and: UIImage(systemName: "house"), vc: moviesVC)
        //let catalog = self.createNavTabBarItem(with: Constants.catalogTabBarName, and: UIImage(named: "heart"), vc: catalogVC)
        let favorites = self.createNavTabBarItem(with: Constants.favoritesTabBarName, and: UIImage(systemName: "heart"), vc: favoritesVC)
        
        self.setViewControllers([movies, /*catalog,*/ favorites], animated: true)
    }
    
    private func createNavTabBarItem(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let item = UINavigationController(rootViewController: vc)
        
        item.tabBarItem.title = title
        item.tabBarItem.image = image
        item.viewControllers.first?.navigationItem.title = title
        
        return item
    }
}
