//
//  MovieSubscribedCollectionViewCell.swift
//  themoviedb
//
//  Created by nicolas castello on 13/09/2023.
//

import UIKit

class MovieSubscribedCollectionViewCell: UICollectionViewCell, ImageFromPathExtensionProtocol {
    var movieImageView: UIImageView?
    
    func populate(image: ImageSetting?) {
        guard let image = image else { return }
        movieImageView = UIImageView()
        setImageView(imageSetting: image)
    }
    
    //MARK: - ImageView
    func setImageView(imageSetting: ImageSetting) {
        guard let movieImageView = movieImageView else { return }
        set(image: imageSetting)
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieImageView)
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 7
        layoutMovieImageView(imageSetting: imageSetting)
    }
    
    func set(image: ImageSetting) {
        guard let movieImageView = movieImageView else { return }
        if let uiImage = image.image {
            movieImageView.image = uiImage
        } else {
            setMovieImage(from: nil)
            setMovieImage(from: image.imagePath)
        }
    }

    private func layoutMovieImageView(imageSetting: ImageSetting) {
        guard let movieImageView = movieImageView else { return }
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        setSize(imageSetting: imageSetting)
    }
    
    func setSize(imageSetting: ImageSetting) {
        guard let movieImageView = movieImageView else { return }
        movieImageView.heightAnchor.constraint(equalToConstant: imageSetting.height ?? 100).isActive = true
        
        if let width = imageSetting.width {
            movieImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        } else {
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        }
    }
}

