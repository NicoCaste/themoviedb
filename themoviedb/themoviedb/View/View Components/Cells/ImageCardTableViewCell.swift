//
//  ImageCardTableViewCell.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import UIKit

class ImageCardTableViewCell: UITableViewCell, ImageFromPathExtensionProtocol {
    var movieImageView: UIImageView?
    
    func populate(imagePath: String?) {
        setPosterImageView(imagePath: imagePath)
    }
    
    func setPosterImageView(imagePath: String?) {
        movieImageView = UIImageView()
        guard let movieImageView else { return }
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieImageView)
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 10
        setMovieImage(from: imagePath)
        
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            movieImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 250),
            movieImageView.heightAnchor.constraint(equalToConstant: 320)
        ])
    }
}
