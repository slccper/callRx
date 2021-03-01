//
//  callloopTests.swift
//  callloopTests
//
//  Created by Su on 2021/2/24.
//  Copyright © 2021 watts. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking

@testable import callloop

class callloopTests: XCTestCase {
	
    let request = URLRequest(url: URL(string: "http://api.github.com")!)
	
    override func setUp() {
		super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
		super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJSON() {
        let observable = URLSession.shared
            .rx.json(request: self.request)
    }

}
