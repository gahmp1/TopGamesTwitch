//
//  TwitchGamesTopTests.swift
//  TwitchGamesTopTests
//
//  Created by Banco Santander Brasil on 30/08/18.
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//
@testable import TwitchGamesTop
import XCTest

class TwitchGamesTopTests: XCTestCase {
    
    //MARK:Properties
    var sut : RootTopGames!
    
    //MARK:Life Cycle Test
    override func setUp() {
        super.setUp()
        sut = Mock.RootTopGamesMock.fistRootTopGamesMock
        
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // XCTAssert to test TopGamesModel
    func testRootGamesAreCompleted() {
        //1. given
        let link = String.loc("FIRST_10_TOP_GAMES")
        
        //2. when
        sut._links = Links(next: link)
        
        //3. then
        XCTAssertEqual(sut._links.next, link, "Next URL isnt valid")
    }
    
    
}
