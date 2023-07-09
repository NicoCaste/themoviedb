//
//  SettingsViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 09/07/2023.
//

import UIKit

class InfoViewController: UIViewController {
    var tableView: GenericTableViewProtocol?
    let viewModel: InfoViewModelProtocol
    
    required init(viewModel: InfoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Info"
        setTableView() 
    }
    
    func setTableView() {
        tableView = GenericTableView(cellsTypeList: viewModel.allowedCells, delegate: self, viewModel: viewModel)
        guard let tableView else { return }
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setTableViewLayout()
    }
    
    private func setTableViewLayout() {
        guard let tableView else { return }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

extension InfoViewController: GenericTableViewDelegate, InfoViewModelDelegate  {
    func didSelectRow(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.settingAction(index: indexPath.row)
    }
    
    func open(url: URL?) {
        guard let url else { return }
        UIApplication.shared.open(url)
    }
}
