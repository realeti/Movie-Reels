//
//  HeaderSupplementaryView.swift
//  Movie-Reels
//
//  Created by Apple M1 on 13.05.2024.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = Constants.movieCollectionHeaderIdentifier
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        let defaultFontSize = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        label.font = UIFont(name: Constants.movieTitleFont, size: Metrics.titleSize) ?? defaultFontSize
        label.textColor = .white
        return label
    }()
    
    lazy var seeAllButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        
        container.font = UIFont(name: Constants.movieTitleFont, size: Metrics.seeAllButtonTitleSize)
        configuration.attributedTitle = AttributedString("See All", attributes: container)
        
        let button = UIButton(configuration: configuration)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(seeAllButton)
        
        setupTitleConstraints()
        setupSeeAllButtonConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitleConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupSeeAllButtonConstraints() {
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seeAllButton.topAnchor.constraint(equalTo: topAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

private struct Metrics {
    static let titleSize: CGFloat = 17.0
    static let seeAllButtonTitleSize: CGFloat = 12.0
    
    init() {}
}
