//
//  CenterTitleTableViewCell.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import UIKit

class CenterTitleTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = UILabel()
    
    func populate(title: String?) {
        setTitleLabel(title: title)
    }
    
    func setTitleLabel(title: String?) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        let textValues = UILabel.TextValues(text: title ?? "", fontSize: 25, font: .NotoSansMyanmarBold, numberOfLines: 2, aligment: .center, textColor: .black)
        titleLabel.set(with: textValues)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
