//
//  SnapshotTests.swift
//  RunnerUITests
//
//  UI Tests for automated App Store screenshot capture
//

import XCTest

class SnapshotTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testScreenshots() throws {
        // Wait for app to load
        sleep(2)
        
        // 1. Dashboard screenshot
        snapshot("01_Dashboard")
        
        // 2. Navigate to Before Visit
        let beforeVisitButton = app.buttons["Before the Visit"]
        if beforeVisitButton.waitForExistence(timeout: 5) {
            beforeVisitButton.tap()
            sleep(2)
            snapshot("02_BeforeVisit")
        }
        
        // 3. Navigate to Library
        let libraryButton = app.buttons["Library"]
        if libraryButton.waitForExistence(timeout: 5) {
            libraryButton.tap()
            sleep(2)
            snapshot("03_Library")
        }
        
        // 4. Navigate to Build Your Own (if exists)
        let buildButton = app.buttons["Build Your Own"]
        if buildButton.waitForExistence(timeout: 3) {
            buildButton.tap()
            sleep(2)
            snapshot("04_BuildYourOwn")
        }
        
        // 5. Return to Dashboard for final screenshot
        let dashboardButton = app.buttons["Dashboard"]
        if dashboardButton.waitForExistence(timeout: 3) {
            dashboardButton.tap()
            sleep(1)
            snapshot("05_DashboardFinal")
        }
    }
}
