//
//  BoxOfficeCollectionViewIconCell.swift
//  BoxOffice
//
//  Created by 김민성 on 2023/08/16.
//

import UIKit

class BoxOfficeCollectionViewIconCell: UICollectionViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(for: .title1, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let rankVariationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private let audienceNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        return label
    }()
    
    func configureCell(rank: String, rankVariation: NSMutableAttributedString?, movieName: String, audienceNumber: String) {
        addSubviews()
        stackViewConstraints()
        configureCellLabels(rank: rank, rankVariation: rankVariation, movieName: movieName, audienceNumber: audienceNumber)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
    
    private func configureCellLabels(rank: String, rankVariation: NSMutableAttributedString?, movieName: String, audienceNumber: String) {
        rankLabel.text = rank
        rankVariationLabel.attributedText = rankVariation
        movieNameLabel.text = movieName
        audienceNumberLabel.text = audienceNumber
    }
}

// MARK: - Add Subviews
extension BoxOfficeCollectionViewIconCell {
    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(rankLabel)
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(rankVariationLabel)
        stackView.addArrangedSubview(audienceNumberLabel)
    }
}

extension BoxOfficeCollectionViewIconCell {
    private func stackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
