//
//  BaseCollectionCell.swift
//  Movie-Reels
//
//  Created by Apple M1 on 15.05.2024.
//

import UIKit

protocol BaseCollectionCell: UICollectionViewCell, MovieViewModelDelegate {
    var viewModel: MovieViewModel? { get set }
}
