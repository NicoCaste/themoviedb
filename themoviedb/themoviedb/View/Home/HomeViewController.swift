//
//  HomeViewController.swift
//  themoviedb
//
//  Created by nicolas castello on 03/07/2023.
//
import UIKit

class HomeViewController: BasicViewController {
    private var searchTextField: GenericSearchTextField?
    private var tableView: GenericTableView?
    private var viewModel: HomeViewModel
    
    required init(viewModel: HomeViewModel) {
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
        getMoviesAndReload(for: .discover)
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
        tableView = GenericTableView(cellsTypeList: [.movieCover], delegate: self)
        guard let tableView  else { return }
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setTableViewLayout()
    }
    
    func getMoviesAndReload(for path: ApiUrlHelper.PathForMovies) {
        Task.detached { [weak self] in
            await self?.viewModel.getMovies(for: path)
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
        guard let movie = viewModel.discoverMovies?.results[indexPath.row] else { return nil }
        let cell = tableView.dequeueReusableCell(withIdentifier: AllowedCells.movieCover.rawValue) as? MovieCoverTableViewCell
        let height: CGFloat? = 200
        let imageSetting = MovieCoverTableViewCell.ImageSetting(imagePath: movie.backdropPath, width: nil, height: height, corner: 10)
        
        cell?.populate(movieTitle: movie.originalTitle, imageSetting: imageSetting)
        return cell
    }
    
    //MARK: Action Delegate
    func didSelectRow(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewModel.getDetailInfo(movie: indexPath.row) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - SearchTextField Delegate
extension HomeViewController: GenericSearchTextFieldDelegate {
    func userInput(text: String) {
        self.tableView?.backToTop()
        let textUrlAllowed = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let path: ApiUrlHelper.PathForMovies = (textUrlAllowed?.isEmpty ?? true || text.isEmpty) ? .discover :  .search(forText: textUrlAllowed ?? text)
        getMoviesAndReload(for: path)
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
            tableView.widthAnchor.constraint(equalToConstant: self.view.frame.width)
        ])
    }
}
