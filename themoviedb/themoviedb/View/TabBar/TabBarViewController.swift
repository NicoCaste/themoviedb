//
//  TabBarViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 09/07/2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var viewModel: TabBarViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white 
        viewModel = TabBarViewModel()
        showTabBar()
    }
    
    private func showTabBar() {
        let navigators = viewModel?.showNavigators()
        setViewControllers(navigators, animated: false)
    }
}
