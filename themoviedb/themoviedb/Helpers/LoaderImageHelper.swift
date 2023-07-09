//
//  LoaderImageHelper.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import Foundation
import UIKit

private let _imageCache = NSCache<AnyObject, AnyObject>()

class LoaderImageHelper {
    var imageCache = _imageCache

    func loadImage(with urlString: String?, completion: @escaping(_ image: UIImage?)-> Void) {
        guard let urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let urlAbsoluteString = url.absoluteString
        if let imageFromCache = imageCache.object(forKey: urlAbsoluteString as AnyObject) as? UIImage {
            completion(imageFromCache)
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                self?.imageCache.setObject(image, forKey: urlAbsoluteString as AnyObject)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                completion(nil)
            }
        }
    }
}
