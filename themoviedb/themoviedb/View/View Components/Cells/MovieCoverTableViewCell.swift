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
    private lazy var blurview: UIView = UIView()
    
    func populate(movieTitle: String?, imagePath: String?) {
        setMovieImage(imagePath: imagePath)
        setBlurView()
        setTitleConfig(movieTitle: movieTitle)
    }
    
    private func setMovieImage(imagePath: String?) {
        setMovieImage(from: nil)
        setMovieImage(from: imagePath)
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieImageView)
        layoutMovieImageView()
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 10
    }
    
    private func setMovieImage(from path: String?) {
        if path == nil {
            set(image: nil)
        } else {
            let imageLoader = LoaderImageHelper()
            let url = ApiUrlHelper.makeURL(for: .getImage, url: .image(path: path))
            imageLoader.loadImage(with: url, completion: { [weak self] movieImage in
                self?.set(image: movieImage)
            })
        }
    }

    private func set(image: UIImage?) {
        var newImage = image
        
        DispatchQueue.main.async {
            if newImage == nil {
                newImage = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate)
                self.movieImageView.tintColor = .lightGray
                self.movieImageView.contentMode = .scaleAspectFit
            }
            self.movieImageView.image = newImage
        }
    }
    
    func setTitleConfig(movieTitle: String?) {
        guard let movieTitle else { return }
        movieTitleLabel.text = movieTitle.capitalized
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieTitleLabel)
        movieTitleLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 20)
        movieTitleLabel.numberOfLines = 2
        movieTitleLabel.textColor = .white
        movieTitleLabel.textAlignment = .left
        movieTitleLabel.sizeToFit()
        movieTitleLabel.setContentHuggingPriority(.required, for: .vertical)
        movieTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        movieTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        movieTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        layoutMovieTitleLabel()
    }
    
    func setBlurView() {
        blurview.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.addSubview(blurview)
        blurview.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
        blurview.clipsToBounds = true
        blurview.layer.cornerRadius = 8
        layoutBlurview()
    }
}

//MARK: Layout
extension MovieCoverTableViewCell {
    //MARK: - Layout MovieTitleLabel
    func layoutMovieTitleLabel() {
        NSLayoutConstraint.activate([
            movieTitleLabel.leadingAnchor.constraint(equalTo: blurview.leadingAnchor, constant: 15),
            movieTitleLabel.bottomAnchor.constraint(equalTo: blurview.bottomAnchor, constant: -5),
            movieTitleLabel.trailingAnchor.constraint(equalTo: blurview.trailingAnchor, constant: -15),
            movieTitleLabel.topAnchor.constraint(equalTo: blurview.topAnchor, constant: 5),
        ])
    }
    
    func layoutBlurview() {
        NSLayoutConstraint.activate([
            blurview.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 15),
            blurview.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -15),
            blurview.trailingAnchor.constraint(lessThanOrEqualTo: movieImageView.trailingAnchor, constant: -15)
        ])
    }
    
    //MARK: - Layout MovieImageView
    private func layoutMovieImageView() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            movieImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
