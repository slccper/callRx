//
//  callloopUITests.swift
//  callloopUITests
//
//  Created by Su on 2021/2/24.
//  Copyright © 2021 watts. All rights reserved.
//

import XCTest

class callloopUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

		let app = XCUIApplication(bundleIdentifier: "com.normal.callloop")
		app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
		super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func showResult(app: XCUIApplication) {
		sleep(6)
		app.customSnapshot()
		let history = app.buttons["history"]
		history.tap()
		sleep(6)
		app.customSnapshot()
		
		let visbleCells = self.visable(items: app.cells.allElementsBoundByIndex)
		if visbleCells.count > 0 {
			let random = Int.random(in: 0..<visbleCells.count)
			let element:XCUIElement = visbleCells[random]
			if  element.inWindow(app: app){
				element.tap()
				sleep(2)
				app.customSnapshot()
			}
		}
		
	}
	// 获取当前可见的item
	func visable(items: [XCUIElement]) -> [XCUIElement] {
		let cells = items
		var visbleCells = [XCUIElement]()
		for i in 0..<cells.count {
			let element = cells[i]
			if element.inWindow(app: XCUIApplication()) {
				visbleCells.append(element)
			}
		}
		return visbleCells
	}
	
    func testExample() {
        // UI tests must launch the application that they test.
        let application = XCUIApplication()
		XCTContext.runActivity(named: "Result") { activity in
			self.showResult(app: application)
		}
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
	
}
extension XCUIApplication {
	func customSnapshot() {
		let attach: XCTAttachment = XCTAttachment(screenshot: self.screenshot(),quality: .low)
		attach.name = String(format: "%d", XCUIApplication.captureCount)
		XCUIApplication.captureCount += 1
		XCTContext.runActivity(named: "Screenshot for \(String(describing: attach.name))") { activity in
			activity.add(attach)
		}
	}
	static var captureCount = 0
}

extension XCUIElement {
	func inWindow(app: XCUIApplication) -> Bool {
		guard self.exists && !self.frame.isEmpty && self.isHittable else { return false }
        return app.windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
