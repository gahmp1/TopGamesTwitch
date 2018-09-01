//
//  TopGamesRequester.swift
//  TwitchGamesTopTests
//
//  Created by Banco Santander Brasil on 01/09/18.
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//
@testable import TwitchGamesTop
import XCTest

class TopGamesRequesterTest: XCTestCase {
    var sut : TopGamesRequester!
    override func setUp() {
        super.setUp()
        sut = TopGamesRequester()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
