//
//  ExtensionUIImage+GrayScale.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import UIKit

extension UIImage {
    
    enum ImageStyle: String {
        case CIColorCrossPolynomial
        case CIColorCube
        case CIColorCubeWithColorSpace
        case CIColorInvert
        case CIColorMap
        case CIColorMonochrome
        case CIColorPosterize
        case CIFalseColor
        case CIMaskToAlpha
        case CIMaximumComponent
        case CIMinimumComponent
        case CIPhotoEffectChrome
        case CIPhotoEffectFade
        case CIPhotoEffectInstant
        case CIPhotoEffectMono
        case CIPhotoEffectNoir
    }
    
    func convertImageToDifferentColorScale(imageStyle: ImageStyle) -> UIImage {
        let currentFilter = CIFilter(name: imageStyle.rawValue)
        currentFilter!.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let context = CIContext(options: nil)
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext()
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
