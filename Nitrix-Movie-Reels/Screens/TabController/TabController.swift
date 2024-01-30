//
//  TabController.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        
        //self.tabBar.barTintColor = .red
        //self.tabBar.tintColor = .green
        //self.tabBar.unselectedItemTintColor = .purple
    }
    
    // MARK: - Tab Bar Setup
    private func setupTabs() {
        let home = self.createTabBarItem(with: "Home", and: UIImage(systemName: "house"), vc: MoviesViewController())
        let home2 = self.createTabBarItem(with: "Home", and: UIImage(systemName: "clock"), vc: MoviesViewController())
        
        self.setViewControllers([home, home2], animated: true)
    }
    
    private func createTabBarItem(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let item = UINavigationController(rootViewController: vc)
        
        item.tabBarItem.title = title
        item.tabBarItem.image = image
        //item.viewControllers.first?.navigationItem.title = title + " Controller"
        
        return item
    }
}
