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
        edgesForExtendedLayout = UIRectEdge.bottom
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        configNavBar()
    }
    
    private func configNavBar() {
        self.navigationController?.isNavigationBarHidden = false 
        let logo = UIImage(named: "appName")
        let imageView = UIImageView(image: logo)
        imageView.frame.size.width = 200
        imageView.frame.size.height = 240
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
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
