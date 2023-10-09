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
    var keyboardActive: Bool = false
    
    required init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeNotificacionCenter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDismissBoard()
        setSearchTextField()
        setTableView()
        getMoviesAndReload(for: .discover, for: .forPage(viewModel.getCurrentPage()))
        setNotificationCenter()
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(movieSubscribedSelected), name: NSNotification.Name.movieSubscribedSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMoviesSubscribed), name: NSNotification.Name.reloadMoviesSubscribed, object: nil)
    }
    
    func removeNotificacionCenter() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.movieSubscribedSelected, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reloadMoviesSubscribed, object: nil)
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
        tableView = GenericTableView(cellsTypeList: viewModel.allowedCells, delegate: self, viewModel: viewModel)
        guard let tableView  else { return }
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setTableViewLayout()
    }
    
    func getMoviesAndReload(for path: ApiUrlHelper.PathForMovies,for searchType: SearchMovie) {
        let currentNumbersOfRows = viewModel.getNumberOfRows(for: 0)
        Task.detached { [weak self] in
            await self?.viewModel.getMovies(for: path, with: searchType)
            let newNumbersofRows = await self?.viewModel.getNumberOfRows(for: FilmsSections.TODAS.rawValue) ?? 0
            if currentNumbersOfRows != newNumbersofRows || newNumbersofRows == 0 {
                await self?.tableView?.reloadTableView()
            }
        }
    }
    
    func goToDetailInfo(from row: Int) {
        guard let viewController = viewModel.getDetailInfo(from: row) else { return }
        pushTo(viewController: viewController)
    }
    
    func goToDetailInfo(from movie: Movie?) {
        guard let movie = movie,
              let viewController = viewModel.getDetailInfo(from: movie)
        else { return }
        pushTo(viewController: viewController)
    }
    
    func pushTo(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func movieSubscribedSelected(notification: Notification) {
        let movie = notification.userInfo?["movie"] as? Movie
        goToDetailInfo(from: movie)
    }
    
    @objc func reloadMoviesSubscribed() {
        tableView?.reloadTableView()
    }
}

//MARK: - TableView Delegate
extension HomeViewController: GenericTableViewDelegate {
    //MARK: Action Delegate
    func didSelectRow(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetailInfo(from: indexPath.row)
    }
    
    func prefetchRowsAt(tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.savePrefetchCell(for: tableView, in: indexPaths)
    }
    
    func willDisplay(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getNumberOfRows(for: FilmsSections.TODAS.rawValue) - 3 {
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
