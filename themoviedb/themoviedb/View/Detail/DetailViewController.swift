//
//  DetailViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import UIKit

class DetailViewModel: BasicViewModel {
    let movieInfo: MovieInfo
    
    init(movieInfo: MovieInfo) {
        self.movieInfo = movieInfo
    }
}

class DetailViewController: BasicViewController {
    let viewModel: DetailViewModel
    
    required init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
