//
//  ListTopGamesWorker.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation


class ListTopGamesWorker {
    
    var topGamesEngine:ListTopGamesWorkerLogic
    init(topGamesEngine: ListTopGamesWorkerLogic) {
        self.topGamesEngine = topGamesEngine
    }
    
    func fetchTopGames(url:String, completionHandler: @escaping FetchTopGamesCompletionHandler) {
        self.topGamesEngine.fetchTopGames(url: url) { (result) in
            completionHandler(result)
        }
    }
}

//MARK: Protocol
protocol ListTopGamesWorkerLogic {
    func fetchTopGames(url:String, completionHandler: @escaping FetchTopGamesCompletionHandler)
}

// MARK: - Typealias
typealias FetchTopGamesCompletionHandler = (TopGamesWorkerResult<RootTopGames>) -> Void

// MARK: - Results
enum TopGamesWorkerResult<U>
{
    case Success(result: U)
    case Failure(error: TopGamesWorkerError)
}

// MARK: - Erros
enum TopGamesWorkerError: Error
{
    case RequestError(RequesterError)
    case ParseError
}

// MARK: - Erros
enum RequesterError: Error
{
    case CannotFetch(Error)
    case NoInternetAcces
    case WrongURLFormat
    case NoData
    case Default
}


