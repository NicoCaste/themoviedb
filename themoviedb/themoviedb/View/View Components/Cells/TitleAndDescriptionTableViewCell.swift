//
//  TitleAndDescriptionTableViewCell.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import UIKit

class TitleAndDescriptionTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = UILabel()
    lazy var descriptionLabel: UILabel = UILabel()
    
    enum DescriptionPosition {
        case next
        case below
    }
    
    func populate(title: UILabel.TextValues, description: UILabel.TextValues, descriptionPosition: DescriptionPosition) {
        setTitle(textValues: title)
        setDescription(textValues: description, descriptionPosition)
    }
    
    func setTitle(textValues: UILabel.TextValues) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.set(with: textValues)
    }
    
    func setDescription(textValues: UILabel.TextValues,_ descriptionPosition: DescriptionPosition) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.set(with: textValues)
        setDescriptionLayout(by: descriptionPosition)
    }
}

extension TitleAndDescriptionTableViewCell {
    //MARK: - Title Layout
    func setTitleLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    //MARK: - Description Layout
    func setDescriptionLayout(by position: DescriptionPosition) {
        setCommonDescriptionLayout()
        
        switch position {
        case .next:
            setNextlayout()
        case .below:
            setBelowLayout()
        }
    }
    
    private func setCommonDescriptionLayout() {
        NSLayoutConstraint.activate([
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setNextlayout() {
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
        ])
    }
    
    private func setBelowLayout() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
    
}
