//
//  TabController.swift
//  Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class TabController: UITabBarController {
    
    lazy var lineIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .darkOrange)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        setupTabs()
        setupLineIndicator()
    }
    
    // MARK: - Tab Bar Setup
    
    private func configureTabBar() {
        tabBar.barTintColor = UIColor(resource: .lightNight)
        tabBar.backgroundColor = UIColor(resource: .lightNight)
        tabBar.tintColor = UIColor(resource: .darkOrange)
        tabBar.unselectedItemTintColor = UIColor(resource: .babyPowder)
    }
    
    private func setupTabs() {
        
        let moviesVC = MoviesViewController()
        let favoritesVC = FavoritesViewController()

        let movies = self.createNavTabBarItem(with: Constants.moviesTabBarName, and: UIImage(systemName: "square.grid.2x2"), vc: moviesVC)
        let favorites = self.createNavTabBarItem(with: Constants.favoritesTabBarName, and: UIImage(systemName: "heart"), vc: favoritesVC)
        
        self.setViewControllers([movies, favorites], animated: true)
    }
    
    private func createNavTabBarItem(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let item = UINavigationController(rootViewController: vc)
        
        item.tabBarItem.title = title
        item.tabBarItem.image = image
        item.viewControllers.first?.navigationItem.title = title
        
        return item
    }
    
    private func setupLineIndicator() {
        guard let tabBarItems = tabBar.items, !tabBarItems.isEmpty else {
            return
        }
        
        let itemWidth = tabBar.frame.width / CGFloat(tabBarItems.count)
        let indicatorWidth = itemWidth / 2
        
        lineIndicator.frame = CGRect(x: itemWidth / 2 - indicatorWidth / 2, y: 0, width: indicatorWidth, height: 2.0)
        tabBar.addSubview(lineIndicator)

        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBarItems = tabBar.items, !tabBarItems.isEmpty else {
            return
        }
        
        let index = tabBarItems.firstIndex(of: item) ?? 0
        let selectedItemWidth = tabBar.frame.width / CGFloat(tabBarItems.count)
        let indicatorWidth = selectedItemWidth / 2
        
        UIView.animate(withDuration: 0.3) {
            self.lineIndicator.frame.origin.x = CGFloat(index) * selectedItemWidth + selectedItemWidth / 2 - indicatorWidth / 2
        }
    }
}
