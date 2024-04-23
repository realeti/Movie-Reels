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
        let favorites = self.createNavTabBarItem(with: Constants.favoritesTabBarName, and: UIImage(resource: .bookmark6X50), vc: favoritesVC)
        
        self.setViewControllers([movies, catalogs, favorites], animated: true)
    }
    
    private func createNavTabBarItem(with title: String, and image: UIImage, vc: UIViewController) -> UINavigationController {
        let item = UINavigationController(rootViewController: vc)
        
        item.tabBarItem.title = title
        setGradientSelectedTitle(for: item.tabBarItem, with: title)
        
        item.tabBarItem.image = image
        item.tabBarItem.selectedImage = generateGradientIcon(for: image)
        
        item.viewControllers.first?.navigationItem.title = title
        
        return item
    }
    
    private func generateGradientIcon(for iconImage: UIImage) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: iconImage.size.width, height: iconImage.size.height)
        gradientLayer.colors = GradientColorStyle.redOrange.colors
        gradientLayer.locations = GradientColorStyle.redOrange.locations
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let maskLayer = CALayer()
        maskLayer.contents = iconImage.cgImage
        maskLayer.frame = gradientLayer.bounds

        gradientLayer.mask = maskLayer

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        gradientLayer.render(in: context)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return gradientImage?.withRenderingMode(.alwaysOriginal)
    }
    
    private func setGradientSelectedTitle(for tabBarItem: UITabBarItem, with text: String) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = GradientColorStyle.redOrange.colors
        gradientLayer.locations = GradientColorStyle.redOrange.locations
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
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
