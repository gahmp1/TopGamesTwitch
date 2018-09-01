//
//  RequesterModel.swift
//  TwitchGamesTop
//
//  Created by Banco Santander Brasil on 01/09/18.
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation

// MARK: - Typealias
typealias RequesterCompletionHandler = (RequesterResult<Data>) -> Void

// MARK: - Results
enum RequesterResult<U>
{
    case Success(result: U)
    case Failure(error: RequesterError)
}

// MARK: - Erros
enum RequesterError: Int
{
    case NoInternetAccess = -1009
    case BadRequest = 400
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case RequestTimeout = 408
    case WrongURLFormat
    case NoData
    case ParseError
    case DefaultError
}

