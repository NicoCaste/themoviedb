//
//  HomeViewModelTest.swift
//  themoviedbTests
//
//  Created by nicolas castello on 07/07/2023.
//

import XCTest
import UIKit
@testable import themoviedb

final class HomeViewModelTest: XCTestCase {
    var sut: HomeViewModel!
    var movieResult: MoviesResult!
    var movieDetail: MovieDetail!
    
    @MainActor override func setUpWithError() throws {
        guard let context = PersistenceController.shared.context else { throw NetWorkingError.unknowError }
        movieResult = MoviesResult(context: context)
        movieDetail = MovieDetail(context: context)
        movieDetail.id = 1
        movieDetail.originalTitle = "test movie"
        movieResult.page = 1
        movieResult.results = [movieDetail!]
        sut = HomeViewModel(repository: MovieRespositoryMock(responseType: .gendreList))
        sut.discoverMovies = movieResult
    }

    override func tearDownWithError() throws {

    }

    func test_getDetailViewController_firstViewModelAllowedCells_equalTrue() throws {
        let vc = sut.getDetailInfo(movie: 0) as? DetailViewController
        XCTAssertEqual(vc?.viewModel.allowedCells.first, AllowedCells.movieCover)
    }

    func test_getGendreList_mockJson_equalMovieGenderName() async {
        await sut.getGenreList()
        let firstGender = sut.genders?.genres?.first
        XCTAssertEqual(firstGender?.name, "Western")
    }
    
    func test_restarMovieList_discoverMovies_nil() {
        sut.restarMovieList()
        XCTAssertEqual(sut.discoverMovies, nil)
    }
    
    func test_getMovies_mockJson_equalMockMovieName() async {
        let repo = MovieRespositoryMock(responseType: .moviesResult)
        sut = HomeViewModel(repository: repo)
        
        await sut.getMovies(for: .discover, with: .forPage(1))
        let movie = sut.discoverMovies
        let movieDetail = movie?.results?[0] as? MovieDetail
        XCTAssertEqual(movie?.page, 1)
        XCTAssertEqual(movieDetail?.originalTitle, "test movie")
    }
    
    func test_getNumbersOfRows_equal_one() {
        let numberOfRows = sut.getNumberOfRows()
        XCTAssertEqual(numberOfRows, 1)
    }
}