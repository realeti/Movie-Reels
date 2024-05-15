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
        configuration.attributedTitle = AttributedString(Constants.seeAllButtonTitle, attributes: container)
        
        let button = UIButton(configuration: configuration)
        setGradientSelectedTitle(for: button, colorStyle: .redOrange, direction: .left)
        
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
    
    private func setGradientSelectedTitle(for button: UIButton, colorStyle: GradientColorStyle, direction: GradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorStyle.colors.map { $0 }
        gradientLayer.locations = colorStyle.locations
        gradientLayer.startPoint = direction.directionType.startPoint
        gradientLayer.endPoint = direction.directionType.endPoint
        
        let defaultAttributes = button.configuration?.attributedTitle?.uiKit
        let buttonTitle = button.configuration?.title ?? ""
        let defaultFont = defaultAttributes?.font as? UIFont ?? UIFont.systemFont(ofSize: 12)
        let textSize = buttonTitle.size(withAttributes: [NSAttributedString.Key.font: defaultFont])
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
        
        button.configuration?.baseForegroundColor = UIColor(patternImage: gradientImage)
    }
}

private struct Metrics {
    static let titleSize: CGFloat = 17.0
    static let seeAllButtonTitleSize: CGFloat = 12.0
    
    init() {}
}
