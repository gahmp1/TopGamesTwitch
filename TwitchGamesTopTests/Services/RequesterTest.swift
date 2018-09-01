//
//  RequesterTest.swift
//  TwitchGamesTopTests
//
//  Created by Banco Santander Brasil on 01/09/18.
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//
@testable import TwitchGamesTop
import XCTest
import Alamofire

class RequesterTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCallListTopGamesRequest() {
        //promise: Completion Request
        let promise = expectation(description: "Completion Generic Request")
        var responseError : RequesterError?
        var responseData : Data?
        guard let url = URL(string: String.loc("FIRST_10_TOP_GAMES")) else {
            responseError = RequesterError.WrongURLFormat
            XCTAssertNil(responseError)
            return
        }
        
        let headers : HTTPHeaders = ["Client-ID": "426elxfoq1u2l77a10fu6ull62z1da"]
        
        Alamofire.request(url,
                          method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                
                if response.result.isFailure {
                    if let error = response.result.error {
                        print("Error while fetching Response: \(String(describing: error)) , Code: \(String(describing: response.response?.statusCode))")
                        if let requesterError = RequesterError(rawValue: response.response?.statusCode ?? RequesterError.NoInternetAccess.rawValue) {
                            responseError = requesterError
                        }
                    }
                    responseError = RequesterError.DefaultError
                }
                
                if let data = response.data {
                    print("Data received from service")
                    responseData = data
                } else {
                    print("No data received from service")
                    responseError = RequesterError.NoData
                }
                promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(responseData)
    }
    
}
