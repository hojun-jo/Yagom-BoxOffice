//
//  BoxOfficeCollectionViewIconCell.swift
//  BoxOffice
//
//  Created by 김민성 on 2023/08/16.
//

import UIKit

class BoxOfficeCollectionViewIconCell: UICollectionViewCell {
    private let contentStackView: UIStackView = {
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
    
    func setLabelText(
        rank: String,
        rankVariation: NSMutableAttributedString?,
        movieName: String,
        audienceNumber: String
    ) {
        rankLabel.text = rank
        rankVariationLabel.attributedText = rankVariation
        movieNameLabel.text = movieName
        audienceNumberLabel.text = audienceNumber
    }
}

// MARK: - Configure UI

extension BoxOfficeCollectionViewIconCell {
    private func configureUI() {
        setUpLayer()
        addSubviews()
        setUpContentStackViewConstraints()
    }
    
    private func setUpLayer() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
    
    private func addSubviews() {
        [rankLabel, movieNameLabel, rankVariationLabel, audienceNumberLabel].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        addSubview(contentStackView)
    }
    
    private func setUpContentStackViewConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
