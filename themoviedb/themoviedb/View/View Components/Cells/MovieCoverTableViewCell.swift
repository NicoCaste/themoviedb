//
//  MovieCoverTableViewCell.swift
//  themoviedb
//
//  Created by nicolas castello on 03/07/2023.
//

import UIKit

class MovieCoverTableViewCell: UITableViewCell {
    private lazy var movieImageView: UIImageView = UIImageView()
    private lazy var movieTitleLabel: UILabel = UILabel()
    
    func populate() {
        contentView.backgroundColor = .black
        setMovieImage()
        setTitleConfig()
    }
    
    private func setMovieImage() {
        setMovieImage(image: UIImage(systemName: "camera"))
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieImageView)
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 7
        layoutMovieImageView()
    }
    
    private func setMovieImage(image: UIImage?) {
        guard let image = image else { return }
        
        DispatchQueue.main.async {
            self.movieImageView.image = image
        }
    }
    
    func setTitleConfig() {
        let title =  ""
        movieTitleLabel.text = title.capitalized
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieTitleLabel)
        movieTitleLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 24)
        movieTitleLabel.textColor = .white
        movieTitleLabel.textAlignment = .left
        layoutMovieTitleLabel()
    }
}

//MARK: Layout
extension MovieCoverTableViewCell {
    //MARK: - Layout MovieTitleLabel
    func layoutMovieTitleLabel() {
        NSLayoutConstraint.activate([
            movieTitleLabel.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 15),
            movieTitleLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -15),
            movieTitleLabel.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -15)
        ])
    }
    
    //MARK: - Layout MovieImageView
    private func layoutMovieImageView() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
