//
//  DetailTopGameWorker.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation


class DetailTopGameWorker {
    
    var topGamesEngine:DetailTopGameWorkerLogic
    init(topGamesEngine: DetailTopGameWorkerLogic) {
        self.topGamesEngine = topGamesEngine
    }
    
    
    //MARK: Services Methods
    func fetchTopGames(game: Game, completionHandler: @escaping FetchDetailTopGameCompletionHandler) {
        self.topGamesEngine.fetchDetailTopGame(game: game, completionHandler: { (result) in
            completionHandler(result)
        })
    }
}

//MARK: Protocol
protocol DetailTopGameWorkerLogic {
   
    //MARK: Services
    func fetchDetailTopGame(game: Game, completionHandler: @escaping FetchDetailTopGameCompletionHandler)
}

// MARK: - Typealias
typealias FetchDetailTopGameCompletionHandler = (DetailTopGameWorkerResult<Game>) -> Void

// MARK: - Results
enum DetailTopGameWorkerResult<U>
{
    case Success(result: U)
    case Failure(error: DetailTopGameWorkerError)
}

// MARK: - Erros
enum DetailTopGameWorkerError: Error
{
    case RequestError(DetailRequesterError)
    case ParseError
}

// MARK: - Erros
enum DetailRequesterError: Error
{
    case CannotFetch
}


