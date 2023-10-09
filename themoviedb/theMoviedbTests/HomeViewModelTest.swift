//
//  HomeViewModelTest.swift
//  themoviedbTests
//
//  Created by nicolas castello on 09/10/2023.
//

import XCTest
@testable import themoviedb

final class HomeViewModelTest: XCTestCase {
    var sut: HomeViewModel!
    let movie = Movie(id: 1, adult: false, backdropPath: "testBackdrop", genreIds: [1,2,4], originalLanguage: "languageTest", originalTitle: "titleTest", overview: "titleOverview", posterPath: "testPoster", releaseDate: "dateTest", voteAverage: 1.2, voteCount: 4)
    
    override func setUpWithError() throws {
        sut = HomeViewModel(repository: MovieRespositoryMock(responseType: .gendreList))
        let coreDataTest = CoreDataTestStack()
        sut.persistence = PersistenceController(context: coreDataTest.mainContext)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_getDetailInfo_index_outOfRange_nil() throws {
        sut.movieList = [movie]
        
        let detailInfo = sut.getDetailInfo(from: 4)
        XCTAssertEqual(detailInfo, nil)
    }
    
    func test_getDetailInfo_index_inRange_DetailViewController() throws {
        sut.movieList = [movie]
        
        let detailInfo = sut.getDetailInfo(from: 0)
        let isDetailViewController = detailInfo?.isKind(of: DetailViewController.self)
        
        XCTAssertEqual(isDetailViewController, true)
    }
    
    func test_getDetailInfo_movie_nil_nil() {
        let detailInfo = sut.getDetailInfo(from: nil)
        XCTAssertEqual(detailInfo, nil)
    }
    
    func test_getDetailInfo_movie_movie_DetailViewController() {
        let detailInfo = sut.getDetailInfo(from: movie)
        let isDetailViewController = detailInfo?.isKind(of: DetailViewController.self)
        XCTAssertEqual(isDetailViewController, true)
    }
    
    func test_restarMovieList() {
        let moviesResult = MoviesResult(page: 1,totalResults: 1,results: [movie])
        sut.discoverMovies = moviesResult
        sut.movieList = [movie]
        sut.prefetch = [0: UITableViewCell()]
        
        sut.restarMovieList()
        
        XCTAssertEqual(sut.discoverMovies?.totalResults, nil)
        XCTAssertEqual(sut.movieList.count, 0)
        XCTAssertEqual(sut.prefetch.count, 0)
    }
    
    func test_reloadSubscribedMovies_persistedMovie_sectionsAllCases() {
        sut.persistence?.save(favMovie: movie)
        
        sut.reloadSubscribedMovies()
        
        XCTAssertEqual(sut.sections, FilmsSections.allCases.count)
    }
    
    func test_reloadSubscribedMovies_withoutPersistedMovie_sectionsGenericMoviesCase() {
        sut.reloadSubscribedMovies()
        
        XCTAssertEqual(sut.sections, FilmsSections.MOVIELIST.rawValue)
    }
    
    func test_updateSubscribedMovies_persistedMovie_subscribedMovies_notEmpty() {
        sut.subscribedMovies = []
        sut.persistence?.save(favMovie: movie)
        
        sut.updateSubscribedMovies()
        
        XCTAssertEqual(sut.subscribedMovies.count, 1)
    }
    
    func test_updateSubscribedMovies_persistedMovie_subscribedMovies_empty() {
        sut.subscribedMovies = []
        
        sut.updateSubscribedMovies()
        
        XCTAssertEqual(sut.subscribedMovies.isEmpty, true)
    }
    
    @MainActor func test_setMovieList_discoverMovie_movieList_count2() {
        sut.movieList = [movie]
        
        let discoverMovie = Movie(id: 2, adult: false, backdropPath: "testBackdrop2", genreIds: [5,6,7], originalLanguage: "languageTest2", originalTitle: "titleTest2", overview: "titleOverview2", posterPath: "testPoster2", releaseDate: "dateTest2", voteAverage: 2.1, voteCount: 5)
        let movieResult = MoviesResult(page: 1,totalResults: 1,results: [discoverMovie])
        sut.discoverMovies = movieResult
        
        sut.setMovieList()
        
        XCTAssertEqual(sut.movieList.count, 2)
        XCTAssertEqual(sut.movieList[1].id, 2)
    }
    
    func test_getCurrentPage_discoverMoviePage2_getPage2() {
        let discoverMovie = Movie(id: 2, adult: false, backdropPath: "testBackdrop2", genreIds: [5,6,7], originalLanguage: "languageTest2", originalTitle: "titleTest2", overview: "titleOverview2", posterPath: "testPoster2", releaseDate: "dateTest2", voteAverage: 2.1, voteCount: 5)
        let movieResult = MoviesResult(page: 2,totalResults: 1,results: [discoverMovie])
        sut.discoverMovies = movieResult
        
        let currentPage = sut.getCurrentPage()
        
        XCTAssertEqual(currentPage, 2)
    }
    
    func test_nextPage_discoverMoviePage2_getPage3() {
        let discoverMovie = Movie(id: 2, adult: false, backdropPath: "testBackdrop2", genreIds: [5,6,7], originalLanguage: "languageTest2", originalTitle: "titleTest2", overview: "titleOverview2", posterPath: "testPoster2", releaseDate: "dateTest2", voteAverage: 2.1, voteCount: 5)
        let movieResult = MoviesResult(page: 2,totalResults: 1,results: [discoverMovie])
        sut.discoverMovies = movieResult
        
        let nextPage = sut.nextPage()
        
        XCTAssertEqual(nextPage, 3)
    }
    
    func test_getPathForUserInput_text_path() {
        let path = sut.getPathForUserInput(text: "test")
        
        XCTAssertEqual(path.stringValue, "search/movie?query=test&")
    }
    
    func test_getNumberOfRows_subscribedMovies_section0_1() {
        sut.persistence?.save(favMovie: movie)
        sut.movieList = [movie,movie,movie]
        let numberOfRows = sut.getNumberOfRows(for: 0)
        
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func test_getNumberOfRows_subscribedMovies_section1_3() {
        sut.persistence?.save(favMovie: movie)
        sut.movieList = [movie,movie,movie]
        let numberOfRows = sut.getNumberOfRows(for: 1)
        
        XCTAssertEqual(numberOfRows, 3)
    }
    
    func test_getNumberOfRows_withoutSubscribedMovies_section0_3() {
        sut.movieList = [movie,movie,movie]
        let numberOfRows = sut.getNumberOfRows(for: 0)
        
        XCTAssertEqual(numberOfRows, 3)
    }
        
    func test_getMovieCell_withoutPrefetch_MovieCoverCell_notNil() {
        let viewController = HomeViewController(viewModel: sut)
        viewController.setTableView()
        sut.movieList = [movie]
        sut.prefetch = [:]
        let cell = sut.getMovieCoverCell(for: 0, in: viewController.tableView!.tableView) as? MovieCoverTableViewCell
        
        XCTAssertNotEqual(cell, nil)
    }
    
    func test_getMovieCell_withPrefetch_withoutMovieList_notNil() {
        let viewController = HomeViewController(viewModel: sut)
        viewController.setTableView()
        sut.movieList = []
        sut.prefetch = [0: UITableViewCell()]
        
        let cell = sut.getMovieCoverCell(for: 0, in: viewController.tableView!.tableView)
        
        XCTAssertNotEqual(cell, nil)
        XCTAssertEqual(sut.prefetch[0], nil)
    }
    
    func test_getMovies_mockJson_equalMockMovieName() async {
        let repo = MovieRespositoryMock(responseType: .moviesResult)
        let testContext = CoreDataTestStack()
        let context = PersistenceController(context: testContext.mainContext).context
        
        sut = HomeViewModel(repository: repo, context: context)

        await sut.getMovies(for: .discover, with: .forPage(1))
        let movieDetail = sut.movieList.first
       
        XCTAssertEqual(movieDetail?.originalTitle, "test movie")
    }
}
