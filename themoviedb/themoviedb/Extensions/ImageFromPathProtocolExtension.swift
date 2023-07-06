//
//  ImageFromPathProtocolExtension.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import Foundation
import UIKit

protocol ImageFromPathExtensionProtocol: AnyObject {
    var movieImageView: UIImageView? { get set }
    func setMovieImage(from path: String?)
}

extension ImageFromPathExtensionProtocol {
    func setMovieImage(from path: String?) {
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
        
        if newImage == nil {
            newImage = UIImage(named: "sleepLogo")
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.movieImageView?.image = newImage
        }
    }
}
