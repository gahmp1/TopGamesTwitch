//
//  Requester.swift
//  TwitchGamesTop
//
//  Created by Banco Santander Brasil on 01/09/18.
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation
import Alamofire

class Requester {
    
    public static let `default`: Requester = {
        return Requester()
    }()
    
    func callRequest(url: String, headers: HTTPHeaders? = nil, completionHandler: @escaping RequesterCompletionHandler) {
        
        guard let url = URL(string: url) else {
            completionHandler(RequesterResult.Failure(error: RequesterError.WrongURLFormat))
            return
        }
        
        Alamofire.request(url,
                          method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    if let error = response.result.error {
                        print("Error while fetching Response: \(String(describing: error)) , Code: \(String(describing: response.response?.statusCode))")
                        if let requesterError = RequesterError(rawValue: response.response?.statusCode ?? RequesterError.NoInternetAccess.rawValue) {
                            completionHandler(RequesterResult.Failure(error: requesterError))
                        }
                    }
                    completionHandler(RequesterResult.Failure(error: RequesterError.DefaultError))
                    return
                }

                guard let data = response.data  else {
                    print("No data received from service")
                    completionHandler(RequesterResult.Failure(error: RequesterError.NoData))
                    return
                }
                completionHandler(RequesterResult.Success(result: data))

        }
    }
}


