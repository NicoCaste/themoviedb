//
//  BasicViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 04/07/2023.
//

import UIKit

class BasicViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        configNavBar()
    }
    
    private func configNavBar() {
        let logo = UIImage(systemName: "video")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: logo)
        imageView.tintColor = .black
        imageView.frame.size.width = 80
        imageView.frame.size.height = 80
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
    }
}

extension UILabel {
    enum StandardFonts: String {
        case NotoSansMyanmarBold = "Noto Sans Myanmar Bold"
        case NotoSansMyanmar = "Noto Sans Myanmar"
    }
    
    struct TextValues {
        var text: String
        var fontSize: CGFloat
        var font: UILabel.StandardFonts
        var numberOfLines: Int
        var aligment: NSTextAlignment
        var textColor: UIColor
    }
    
    func set(with textValue: TextValues) {
        self.text = textValue.text
        self.font = UIFont(name: textValue.font.rawValue, size: textValue.fontSize)
        self.numberOfLines = textValue.numberOfLines
        self.textColor = textValue.textColor
        self.textAlignment = textValue.aligment
    }
}
