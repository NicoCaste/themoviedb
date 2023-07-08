//
//  themoviedbUITests.swift
//  themoviedbUITests
//
//  Created by nicolas castello on 03/07/2023.
//

import XCTest

final class themoviedbUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchEnvironment = ["ui_test_variable":"verbose"]
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    // create a function to wait for prediction
    func waitNotExistance(for element: XCUIElement, timeout: Double = 5) {
        let notExists = NSPredicate(format: "exists != 1")
        let elementShown = expectation(for: notExists, evaluatedWith: element)
        wait(for: [elementShown], timeout: timeout, enforceOrder: false)
    }

    func test_FirstLoadHome() throws {
        let textField = app.textFields["Search Movie"]
        print("textFieldFrame: ", textField.frame)
        XCTAssertTrue(textField.exists)
        
        let movieTitleText = app.tables.staticTexts["Movie Test"]
        XCTAssertTrue(movieTitleText.exists)
    }
    
    func test_image_consistense() {
        let cells = app.cells.allElementsBoundByIndex
        
        guard let imageCell = cells.first else {
            XCTFail("cell not founder")
            return
        }
        
        let homeImage = imageCell.children(matching: .image).firstMatch
        let imageCellFrame = homeImage.frame
        //defined in homeViewModel
        XCTAssertEqual(imageCellFrame.height, 200)
        homeImage.tap()
        let screenBefore = homeImage.screenshot()
        homeImage.tap()
   
        sleep(1)
        app.navigationBars["themoviedb.DetailView"].buttons["Home"].tap()
        sleep(1)
        let screenShotAfter = homeImage.screenshot()
      
        XCTAssertEqual(screenBefore.pngRepresentation, screenShotAfter.pngRepresentation)
    }
    
    func test_appflow() {
        let cells = app.cells.allElementsBoundByIndex
        
        guard let imageCell = cells.first else {
            XCTFail("cell not founder")
            return
        }
        
        let homeImage = imageCell.children(matching: .image).firstMatch
 
        homeImage.tap()
        //DetailView
        sleep(3)
        let tablesQuery = XCUIApplication().tables
        let title = tablesQuery.staticTexts["Movie Test"]
        let image = tablesQuery.images.firstMatch
        XCTAssertEqual(title.exists, true)
        //frame defined in detailviewmodel
        XCTAssertEqual(image.frame.width, 220)
        XCTAssertEqual(image.frame.height, 300)
    }
}
