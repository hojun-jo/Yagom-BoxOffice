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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        rankLabel.text = nil
        rankVariationLabel.text = nil
        movieNameLabel.text = nil
        audienceNumberLabel.text = nil
    }
    
    func setLabelText(rank: String, rankVariation: NSMutableAttributedString?, movieName: String, audienceNumber: String) {
        rankLabel.text = rank
        rankVariationLabel.attributedText = rankVariation
        movieNameLabel.text = movieName
        audienceNumberLabel.text = audienceNumber
    }
}

// MARK: - Configure UI

extension BoxOfficeCollectionViewListCell {
    private func configureUI() {
        setUpView()
        addSubviews()
        setUpConstraints()
    }
    
    private func setUpView() {
        accessories = [.disclosureIndicator()]
    }
    
    private func addSubviews() {
        [rankLabel, rankVariationLabel, movieNameLabel, audienceNumberLabel].forEach {
            addSubview($0)
        }
    }

    private func setUpConstraints() {
        setUpRankLabelConstraints()
        setUpRankVariationLabelConstraints()
        setUpMovieNameLabelConstraints()
        setUpAudienceNumberLabelConstraints()
        setUpSeparatorConstraints()
    }
    
    private func setUpSeparatorConstraints() {
        separatorLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    private func setUpRankLabelConstraints() {
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rankLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            rankLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            rankLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setUpRankVariationLabelConstraints() {
        rankVariationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rankVariationLabel.topAnchor.constraint(equalTo: rankLabel.bottomAnchor),
            rankVariationLabel.centerXAnchor.constraint(equalTo: rankLabel.centerXAnchor),
            rankVariationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setUpMovieNameLabelConstraints() {
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 24),
            movieNameLabel.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor),
            movieNameLabel.centerYAnchor.constraint(equalTo: rankLabel.centerYAnchor),
            movieNameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8)
        ])
    }
    
    private func setUpAudienceNumberLabelConstraints() {
        audienceNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            audienceNumberLabel.leadingAnchor.constraint(equalTo: movieNameLabel.leadingAnchor),
            audienceNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            audienceNumberLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 4),
            audienceNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
