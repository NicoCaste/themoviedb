//
//  HomeViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 03/07/2023.
//
import UIKit

class HomeViewController: BasicViewController {
    private var searchTextField: GenericSearchTextField?
    var tableView: GenericTableViewProtocol?
    var prefetch: [Int: UITableViewCell] = [:]
    private var viewModel: HomeViewModelProtocol
    
    required init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchTextField()
        setTableView()
        getMoviesAndReload(for: .discover, for: .forPage(viewModel.getCurrentPage()))
    }
    
    private func setSearchTextField() {
        //TODO: localized text
        searchTextField = GenericSearchTextField(delegate: self, placeholderText: "Search Movie")
        guard let searchTextField else { return }
        self.view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        setSearchTextFieldLayout()
    }
    
    private func setTableView() {
        tableView = GenericTableView(cellsTypeList: viewModel.allowedCells, delegate: self)
        guard let tableView  else { return }
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setTableViewLayout()
    }
    
    func getMoviesAndReload(for path: ApiUrlHelper.PathForMovies,for searchType: PersistenceController.SearchMovie) {
        Task.detached { [weak self] in
            await self?.viewModel.getMovies(for: path, with: searchType)
            await self?.tableView?.reloadTableView()
        }
    }
}

//MARK: - TableView Delegate
extension HomeViewController: GenericTableViewDelegate {
    func numberOfRowInSection() -> Int {
        viewModel.getNumberOfRows()
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        viewModel.getCell(for: tableView, in: indexPath.row)
    }
    
    //MARK: Action Delegate
    func didSelectRow(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewModel.getDetailInfo(movie: indexPath.row) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func prefetchRowsAt(tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.savePrefetchCell(for: tableView, in: indexPaths)
    }
    
    func willDisplay(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getNumberOfRows() - 3 {
            let page = viewModel.nextPage()
            getMoviesAndReload(for: .discover, for: .forPage(page))
        }
    }
}

//MARK: - SearchTextField Delegate
extension HomeViewController: GenericSearchTextFieldDelegate {
    func userInput(text: String) {
        self.tableView?.backToTop()
        viewModel.restarMovieList()
        let path = viewModel.getPathForUserInput(text: text)
        getMoviesAndReload(for: path, for: .forTitle(text))
    }
}

//MARK: - Layout
extension HomeViewController {
    private func setSearchTextFieldLayout() {
        guard let searchTextField else { return }
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant:  -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setTableViewLayout() {
        guard let tableView, let searchTextField else { return }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
