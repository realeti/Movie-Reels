//
//  CarouselSection.swift
//  Movie-Reels
//
//  Created by Apple M1 on 13.05.2024.
//

import UIKit

final class CarouselSection {
    private weak var collectionView: UICollectionView?
    private weak var pageControl: UIPageControl?
    private var scales: [IndexPath: CGFloat]

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.scales = [:]
    }

    func layoutSection() -> NSCollectionLayoutSection {
        let itemScale: CGFloat = 0.75
        let sectionInset: CGFloat = 16.0
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemScale), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, environment) in
            guard let self else { return }
            
            let items = visibleItems.filter { $0.representedElementKind == nil}
            let width = environment.container.effectiveContentSize.width
            let itemWidth = width * itemScale
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - width / 2.0)
                let minScale: CGFloat = 0.85
                let scale: CGFloat = minScale + (1.0 - minScale) * exp(-distanceFromCenter / (itemWidth / 2))
                self.scales[item.indexPath] = scale
                guard let cell = self.collectionView?.cellForItem(at: item.indexPath) else { return }
                self.applyTransform(to: cell, at: item.indexPath)
            }
        }
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.05))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        return section
    }

    func applyTransform(to cell: UIView, at indexPath: IndexPath) {
        guard let scale = scales[indexPath] else { return }
        cell.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
