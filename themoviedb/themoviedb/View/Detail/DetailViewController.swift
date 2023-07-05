//
//  DetailViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 05/07/2023.
//

import UIKit

class DetailViewController: BasicViewController {
    var tableView: GenericTableView?
    var movieImage: UIImage?
    
    let viewModel: DetailViewModel
    let allowedCells: [AllowedCells] =  [.movieCover, .centerTitleTableViewCell,  .titleAndDescriptionTableViewCell]
    
    required init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    private func setTableView() {
        tableView = GenericTableView(cellsTypeList: allowedCells, delegate: self)
        guard let tableView  else { return }
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setTableViewLayout()
    }
    
    func getMovieImage() {
        viewModel.getMovieImage(completion: { [weak self] image in
            self?.movieImage = image
            self?.tableView?.reloadTableView()
        })
    }
    
    private func setTableViewLayout() {
        guard let tableView else { return }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.widthAnchor.constraint(equalToConstant: self.view.frame.width)
        ])
    }
    
    
}

extension DetailViewController: GenericTableViewDelegate {
    func numberOfRowInSection() -> Int {
        viewModel.getNumbersOfCells()
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let rowCase = DetailViewModel.DetailTableCases(rawValue: indexPath.row)
        return viewModel.getCell(for: tableView, in: rowCase)
    }
}
