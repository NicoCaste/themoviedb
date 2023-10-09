//
//  MovieCoverTableViewCell.swift
//  themoviedb
//
//  Created by nicolas castello on 03/07/2023.
//

import UIKit

struct ImageSetting {
    var imagePath: String?
    var width: CGFloat?
    var height: CGFloat?
    var corner: CGFloat?
    var image: UIImage?
}

class MovieCoverTableViewCell: UITableViewCell, ImageFromPathExtensionProtocol {
    var movieImageView: UIImageView?
    private lazy var movieTitleLabel: UILabel = UILabel()
    private lazy var blurview: UIView = UIView()
    
    func populate(movieTitle: String?, imageSetting: ImageSetting) {
        movieImageView = UIImageView()
        setMovieImage(imageSetting: imageSetting)
        setBlurView(movieTitle: movieTitle)
        setTitleConfig(movieTitle: movieTitle)
    }

    private func setMovieImage(imageSetting: ImageSetting) {
        guard let imageView = movieImageView else { return }
        set(image: imageSetting)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        if let corner = imageSetting.corner {
            imageView.layer.masksToBounds = true 
            imageView.layer.cornerRadius = corner
        }
        layoutMovieImageView(imageSetting: imageSetting)
    }
    
    func set(image: ImageSetting) {
        guard let imageView = movieImageView else { return }
        
        if let uiImage = image.image {
            imageView.image = uiImage
        } else {
            setMovieImage(from: nil)
            setMovieImage(from: image.imagePath)
        }
    }

    func setTitleConfig(movieTitle: String?) {
        guard let movieTitle else { return }
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieTitleLabel)
        let textValues = UILabel.TextValues(text: movieTitle.capitalized, fontSize: 20, font: .NotoSansMyanmarBold, numberOfLines: 2, aligment: .left, textColor: .white)
        
        movieTitleLabel.set(with: textValues)
        movieTitleLabel.sizeToFit()
        movieTitleLabel.setContentHuggingPriority(.required, for: .vertical)
        movieTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        movieTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
        movieTitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        layoutMovieTitleLabel()
    }
    
    //gray background for title.
    func setBlurView(movieTitle: String?) {
        guard movieTitle != nil else { return }
        blurview.translatesAutoresizingMaskIntoConstraints = false
        movieImageView?.addSubview(blurview)
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
        guard let imageView = movieImageView else { return }
        NSLayoutConstraint.activate([
            blurview.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15),
            blurview.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
            blurview.trailingAnchor.constraint(lessThanOrEqualTo: imageView.trailingAnchor, constant: -15)
        ])
    }
    
    //MARK: - Layout MovieImageView
    private func layoutMovieImageView(imageSetting: ImageSetting) {
        guard let movieImageView else { return }
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        setSize(imageSetting: imageSetting)
    }
    
    func setSize(imageSetting: ImageSetting) {
        guard let movieImageView else { return }
        movieImageView.heightAnchor.constraint(equalToConstant: imageSetting.height ?? 200).isActive = true
        
        if let width = imageSetting.width {
            movieImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        } else {
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        }
    }
}
