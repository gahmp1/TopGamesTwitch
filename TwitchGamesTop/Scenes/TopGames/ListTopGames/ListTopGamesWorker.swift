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
    
    //MARK: Core Data Methods
    func saveUpdateTopGamesInCoreData(url:String,listGames:[Game], completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler) {
        self.topGamesEngine.saveUpdateTopGamesInCoreData(url: url, listGames: listGames) { (result) in
            completionHandler(result)
        }
    }
    
    func fetchTopGamesInCoreData(completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler) {
        self.topGamesEngine.fetchTopGamesInCoreData(){ (result) in
            completionHandler(result)
        }
    }
    
    func deleteTopGamesInCoreData(completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler) {
        self.topGamesEngine.deleteTopGamesInCoreData(){ (result) in
            completionHandler(result)
        }
    }
    
    
    //MARK: Services Methods
    func fetchTopGames(url:String, completionHandler: @escaping FetchTopGamesCompletionHandler) {
        self.topGamesEngine.fetchTopGames(url: url) { (result) in
            completionHandler(result)
        }
    }
}

//MARK: Protocol
protocol ListTopGamesWorkerLogic {
    //MARK: Core Data
    func saveUpdateTopGamesInCoreData(url:String,listGames:[Game], completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler)
    func deleteTopGamesInCoreData(completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler)
    func fetchTopGamesInCoreData(completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler)
    
    //MARK: Services
    func fetchTopGames(url:String, completionHandler: @escaping FetchTopGamesCompletionHandler)
}

// MARK: - Typealias
typealias FetchTopGamesCompletionHandler = (TopGamesWorkerResult<RootTopGames>) -> Void
typealias FetchTopGamesCoreDataCompletionHandler = (TopGamesCoreDataWorkerResult<RootTopGames>) -> Void

// MARK: - Results
enum TopGamesWorkerResult<U>
{
    case Success(result: U)
    case Failure(error: RequesterError)
}

enum TopGamesCoreDataWorkerResult<U>
{
    case Success(result: U)
    case Finish(hasFinished: Bool)
}


