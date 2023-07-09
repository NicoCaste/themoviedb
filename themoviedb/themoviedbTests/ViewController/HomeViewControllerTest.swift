//
//  HomeViewControllerTest.swift
//  themoviedbTests
//
//  Created by nicolas castello on 07/07/2023.
//

import XCTest
@testable import themoviedb

extension Notification.Name {
    static let callReloadTableView = NSNotification.Name("callReloadTableView")
    static let callBacktoTheTop = NSNotification.Name("callReloadTableView")
    static let callGetMovies = NSNotification.Name("callGetMovies")
    static let callDetailInfo = NSNotification.Name("callDetailInfo")
}

final class HomeViewControllerTest: XCTestCase {
    var sut: HomeViewController!
    var navigationController: UINavigationController!
    var viewModel: HomeViewModelProtocol = HomeViewModelMock()
    
    override func setUpWithError() throws {
        sut = HomeViewController(viewModel: viewModel)
        sut.loadViewIfNeeded()
        navigationController = UINavigationController(rootViewController: sut)
    }

    override func tearDownWithError() throws {
      sut = nil
    }
    
    var titleCalled = ""
    func test_getMoviesAndReload_callViewModelGetMovies() {
        let title = "test"
        let asyncWaitDuration = 3.0
        let description = "getMovies viewModel async, viewController with Task sync"
        let expectation = XCTestExpectation( description: description )
        NotificationCenter.default.addObserver(self, selector: #selector(notificationTitleCalled(_:)), name: .callGetMovies, object: nil)
    
        self.sut.getMoviesAndReload(for: .discover, for: .forTitle(title))
    
        DispatchQueue.main.asyncAfter(deadline: .now() + asyncWaitDuration) {
            XCTAssertEqual(self.titleCalled, title)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: asyncWaitDuration)
    }
    
    func test_didSelectRow_newViewController_DetailView() {
        let indexPath = IndexPath(row: 0, section: 1)
        let tableView = UITableView()
        sut.didSelectRow(tableView, didSelectRowAt: indexPath)
        RunLoop.current.run(until: Date())
        XCTAssertNotEqual(navigationController.topViewController as? DetailViewController, nil)
    }
    
    var backToTheTopCalled: Bool = false
    func test_userInput_text_title_equal() {
        let title = "test_title"
        let asyncWaitDuration = 0.5
        let description = "call get back top, UserInput restartMovieList, getMoviesAndReload"
        let expectation = XCTestExpectation( description: description )
        sut.tableView = GenericTableViewMock(delegate: sut)
       
        NotificationCenter.default.addObserver(self, selector: #selector(notificationTitleCalled(_:)), name: .callGetMovies, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationBackToTheTopCalled(_:)), name: .callBacktoTheTop, object: nil)
        
        //UserInput
        sut.userInput(text: title)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + asyncWaitDuration) {
            XCTAssertEqual(self.titleCalled, title)
            XCTAssertEqual(self.backToTheTopCalled, true)
            XCTAssertEqual(self.viewModel.getNumberOfRows(), 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: asyncWaitDuration)
    }
}

extension HomeViewControllerTest {
    @objc func notificationBackToTheTopCalled(_ notification: Notification) {
        let infoMovie = notification.userInfo?["backToTheTop"] as? Bool
        backToTheTopCalled = infoMovie ?? false
    }
    
    @objc func notificationTitleCalled(_ notification: Notification) {
        let infoMovie = notification.userInfo?["infoMovie"] as? String
        titleCalled = infoMovie ?? ""
    }
}
