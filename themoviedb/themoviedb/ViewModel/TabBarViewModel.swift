//
//  TabBarViewModel.swift
//  themoviedb
//
//  Created by nicolas castello on 09/07/2023.
//

import Foundation
import UIKit

class TabBarViewModel {
    private let webService = UrlSessionWebService()
    private let repository: TheMovieRepository
    
    init() {
        self.repository =  TheMovieRepository(webService: webService)
    }
    
    func showNavigators() -> [UINavigationController] {
        var navigators: [UINavigationController] = []
        let imageCharacters = UIImage(systemName: "house")
        let imageInfo = UIImage(systemName: "gearshape")
        let home  = goToHome()
        let setting = goToInfo()
        
        home.tabBarItem = UITabBarItem(title: "Home", image: imageCharacters, tag: 1)
        home.tabBarItem.badgeColor = .black 
        home.navigationBar.prefersLargeTitles = true
        
        setting.tabBarItem = UITabBarItem(title: "Settings", image: imageInfo, tag: 2)
        setting.navigationBar.prefersLargeTitles = true
        
        navigators.append(home)
        navigators.append(setting)
        
        return navigators
    }
    
    private func goToHome() -> UINavigationController {
        var viewModel: HomeViewModel!
        viewModel = HomeViewModel(repository: repository)
        let home = HomeViewController(viewModel: viewModel)
        home.edgesForExtendedLayout = UIRectEdge.bottom
        home.extendedLayoutIncludesOpaqueBars = true
        home.navigationItem.largeTitleDisplayMode = .never
        let navigation = UINavigationController(rootViewController: home)
        navigation.isToolbarHidden = true
        navigation.hidesBarsWhenKeyboardAppears = true 
        return navigation
    }
    
    private func goToInfo() -> UINavigationController {
        let viewModel = InfoViewModel(repository: repository)
        let infoVc = InfoViewController(viewModel: viewModel)
        infoVc.navigationItem.largeTitleDisplayMode = .always
        let navigation = UINavigationController(rootViewController: infoVc)
        return navigation
    }
}
