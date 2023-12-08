//
//  BoxOfficeCollectionViewCell.swift
//  BoxOffice
//
//  Created by EtialMoon, Minsup on 2023/07/31.
//

import UIKit

final class BoxOfficeCollectionViewListCell: UICollectionViewListCell {
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(for: .largeTitle, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let rankVariationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let audienceNumberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    func configureCell(rank: String, rankVariation: NSMutableAttributedString?, movieName: String, audienceNumber: String) {
        addSubviews()
        setUpConstraints()
        configureCellLabels(rank: rank, rankVariation: rankVariation, movieName: movieName, audienceNumber: audienceNumber)
    }
    
    private func configureCellLabels(rank: String, rankVariation: NSMutableAttributedString?, movieName: String, audienceNumber: String) {
        rankLabel.text = rank
        rankVariationLabel.attributedText = rankVariation
        movieNameLabel.text = movieName
        audienceNumberLabel.text = audienceNumber
    }
}

// MARK: - Add Subviews
extension BoxOfficeCollectionViewListCell {
    private func addSubviews() {
        [rankLabel, rankVariationLabel, movieNameLabel, audienceNumberLabel].forEach {
            addSubview($0)
        }
        
        accessories = [.disclosureIndicator()]
    }
}

// MARK: - Constraints
extension BoxOfficeCollectionViewListCell {
    private func setUpConstraints() {
        rankLabelConstraints()
        rankVariationLabelConstraints()
        movieNameLabelConstraints()
        audienceNumberLabelConstraints()
        separatorConstraints()
    }
    
    private func separatorConstraints() {
        separatorLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    private func rankLabelConstraints() {
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            rankLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            rankLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func rankVariationLabelConstraints() {
        rankVariationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankVariationLabel.topAnchor.constraint(equalTo: rankLabel.bottomAnchor),
            rankVariationLabel.centerXAnchor.constraint(equalTo: rankLabel.centerXAnchor),
            rankVariationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func movieNameLabelConstraints() {
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieNameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 24),
            movieNameLabel.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor),
            movieNameLabel.centerYAnchor.constraint(equalTo: rankLabel.centerYAnchor),
            movieNameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8)
        ])
    }
    
    private func audienceNumberLabelConstraints() {
        audienceNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            audienceNumberLabel.leadingAnchor.constraint(equalTo: movieNameLabel.leadingAnchor),
            audienceNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            audienceNumberLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 4),
            audienceNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
