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
        
        configureTabBar()
        setupTabs()
    }

    // MARK: - TabBar Setup
    
    private func configureTabBar() {
        tabBar.barTintColor = UIColor(resource: .shadow)
        tabBar.backgroundColor = UIColor(resource: .shadow)
        tabBar.unselectedItemTintColor = UIColor(resource: .lightSilver)
        tabBar.backgroundImage = UIImage()
    }
    
    private func setupTabs() {
        
        let moviesVC = MoviesViewController()
        let catalogVC = CatalogViewController()
        let favoritesVC = FavoritesViewController()

        let movies = self.createNavTabBarItem(with: Constants.moviesTabBarName, and: UIImage(resource: .home), vc: moviesVC)
        let catalogs = self.createNavTabBarItem(with: Constants.catalogTabBarName, and: UIImage(resource: .catalog), vc: catalogVC)
        let favorites = self.createNavTabBarItem(with: Constants.favoritesTabBarName, and: UIImage(resource: .bookmark), vc: favoritesVC)
        self.setViewControllers([movies, catalogs, favorites], animated: true)
    }
    // 1, 7
    private func createNavTabBarItem(with title: String, and image: UIImage, vc: UIViewController) -> UINavigationController {
        let item = UINavigationController(rootViewController: vc)
        
        item.tabBarItem.title = title
        setGradientSelectedTitle(for: item.tabBarItem, with: title, colorStyle: .redOrange, direction: .left)
        
        item.tabBarItem.image = image
        item.tabBarItem.selectedImage = UIImage.generateGradientIcon(for: image, colorStyle: .redOrange, direction: .left)
        item.viewControllers.first?.navigationItem.title = title
        
        return item
    }
    
    private func setGradientSelectedTitle(for tabBarItem: UITabBarItem, with text: String, colorStyle: GradientColorStyle, direction: GradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorStyle.colors.map { $0 }
        gradientLayer.locations = colorStyle.locations
        gradientLayer.startPoint = direction.directionType.startPoint
        gradientLayer.endPoint = direction.directionType.endPoint
        
        let defaultAttributes = tabBarItem.titleTextAttributes(for: .selected)
        let defaultFont = defaultAttributes?[NSAttributedString.Key.font] as? UIFont ?? UIFont.systemFont(ofSize: 12)
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: defaultFont])
        gradientLayer.frame = CGRect(origin: .zero, size: textSize)
        
        UIGraphicsBeginImageContextWithOptions(textSize, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        gradientLayer.render(in: context)
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        UIGraphicsEndImageContext()
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(patternImage: gradientImage)
        ]
        
        tabBarItem.setTitleTextAttributes(textAttributes, for: .selected)
    }
}
