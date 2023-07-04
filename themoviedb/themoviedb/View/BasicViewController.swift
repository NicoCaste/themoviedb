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
        configNavBar()
    }
    
    private func configNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.black
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
