//
//  MovieCell.swift
//  Nitrix-Movie-Reels
//
//  Created by Apple M1 on 30.01.2024.
//

import UIKit

class MovieCell: UITableViewCell {

    static let reuseIdentifier = Constants.movieCellIdentifier
    
    lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(movieNameLabel)
        
        movieNameLabel.font = .boldSystemFont(ofSize: Constants.movieCellNameSize)
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.movieCellTopIndent),
            movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.movieCellLeadingIndent),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.movieCellTraillingIndent),
            movieNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.movieCellBottomIndent)
        ])
    }
}
