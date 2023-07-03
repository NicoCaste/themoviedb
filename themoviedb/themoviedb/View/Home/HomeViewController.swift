//
//  HomeViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 03/07/2023.
//

import UIKit

class HomeViewController: UIViewController {
    private var tableView: GenericTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setTableView()
    }
    
    func setTableView() {
        tableView = GenericTableView(cellsTypeList: [.movieCover], delegate: self)
        guard let tableView  else { return }
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setTableViewLayout()
    }
}

extension HomeViewController: GenericTableViewDelegate {
    func numberOfRowInSection() -> Int {
        return 100
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieCover.rawValue) as? MovieCoverTableViewCell
        cell?.populate()
        return cell 
    }
    
    //MARK: Action Delegate
    func didSelectRow(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

//MARK: - Layout
extension HomeViewController {
    func setTableViewLayout() {
        guard let tableView else { return }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 500),
            tableView.widthAnchor.constraint(equalToConstant: self.view.frame.width)
        ])
    }
}
