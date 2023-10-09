//
//  CenterTitleTableViewCell.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import UIKit

protocol CenterTitleLikeButtonDelegate: AnyObject {
    func heartButton(isLiked: Bool)
}

class CenterTitleTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = UILabel()
    lazy var likeHeartImageView: UIImageView = UIImageView()
    private var isLiked: Bool = false
    private var renderLikeButton: Bool = false
    weak var delegate: CenterTitleLikeButtonDelegate?
    
    func populate(title: String?, withLikeButton: Bool, startLiked: Bool = false) {
        self.renderLikeButton = withLikeButton
        isLiked = startLiked
        if withLikeButton {
            setLikeHeartImageView()
        }
        setTitleLabel(title: title)
    }
    
    func setLikeHeartImageView() {
        likeHeartImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeHeartImageView)
        setLikedButton()
        likeHeartImageView.tintColor = .red
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeHeart(tapGestureRecognizer:)))
        likeHeartImageView.isUserInteractionEnabled = true
        likeHeartImageView.addGestureRecognizer(tapGesture)
        likeHeartImageViewLayout()
    }
    
    func setTitleLabel(title: String?) {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        let textValues = UILabel.TextValues(text: title ?? "", fontSize: 25, font: .NotoSansMyanmarBold, numberOfLines: 2, aligment: .left, textColor: .black)
        titleLabel.set(with: textValues)
        titleLableLayout()
    }
    
    @objc func likeHeart(tapGestureRecognizer: UITapGestureRecognizer) {
        isLiked = !isLiked
        setLikedButton()
        delegate?.heartButton(isLiked: isLiked)
    }
    
    func setLikedButton() {
        let imageName = isLiked ? "heart.fill" : "heart"
        likeHeartImageView.image = UIImage(systemName: imageName)
    }
}

//MARK: Layout
extension CenterTitleTableViewCell {
//MARK: - LikeHeartImage Layout
    func likeHeartImageViewLayout() {
        NSLayoutConstraint.activate([
            likeHeartImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            likeHeartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            likeHeartImageView.heightAnchor.constraint(equalToConstant: 30),
            likeHeartImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
//MARK: - TitleLabel Layout
    func titleLableLayout() {
        let trailingAnchor = renderLikeButton ? likeHeartImageView.leadingAnchor : contentView.trailingAnchor
        let trailingConstant: CGFloat = renderLikeButton ? -10 : -20
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant)
        ])
    }
}
