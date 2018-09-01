//
//  ListTopGamesInteractor.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation
import CoreData

protocol ListTopGamesBusinessLogic {
    func fetchTopGames(request:TopGames.Service.Request)
    func saveUpdateTopGamesInCoreData(request: TopGames.CoreData.SaveUpdate.Request)
    func fetchTopGamesInCoreData(request: TopGames.CoreData.Fetch.Request)
    func deleteTopGamesInCoreData(request: TopGames.CoreData.Delete.Request)
}
class ListTopGamesInteractor: ListTopGamesBusinessLogic {
   
    
    //MARK: Properties
    var presenter: ListTopGamesPresentationLogic?
    var worker: ListTopGamesWorker?
    

    //MARK: Methods Interactor Top Games Core Data
    func fetchTopGamesInCoreData(request: TopGames.CoreData.Fetch.Request) {
        worker = ListTopGamesWorker(topGamesEngine: TopGamesRequester())
        var response = TopGames.CoreData.Fetch.Response()
        
        worker?.fetchTopGamesInCoreData(completionHandler: { (result) in
            switch result {
                
            case .Success(let rootTopGames):
                response.rootTopGames = rootTopGames
                response.hasFinished = true
                self.presenter?.presentFetchedTopGamesInCoreData(response: response)
                break
            case .Finish(let hasFinished):
                response.rootTopGames = nil
                response.hasFinished = hasFinished
                self.presenter?.presentFetchedTopGamesInCoreData(response: response)
                break
            }
        })
    }
    
    func saveUpdateTopGamesInCoreData(request: TopGames.CoreData.SaveUpdate.Request) {
        worker = ListTopGamesWorker(topGamesEngine: TopGamesRequester())
        var response = TopGames.CoreData.SaveUpdate.Response()
        
        worker?.saveUpdateTopGamesInCoreData(url:request.nextUrl ?? String.loc("FIRST_10_TOP_GAMES"),listGames: request.listGames ?? [Game](), completionHandler: { (result) in
            switch result {
                
            case .Success(let rootTopGames):
                response.rootTopGames = rootTopGames
                response.hasFinished = true
                self.presenter?.presentSavedUpdatedTopGamesInCoreData(response: response)
                break
            case .Finish(let hasFinished):
                response.rootTopGames = nil
                response.hasFinished = hasFinished
                self.presenter?.presentSavedUpdatedTopGamesInCoreData(response: response)
                break
            }
        })
    }
    
    func deleteTopGamesInCoreData(request: TopGames.CoreData.Delete.Request) {
        worker = ListTopGamesWorker(topGamesEngine: TopGamesRequester())
        var response = TopGames.CoreData.Delete.Response()
        
        worker?.deleteTopGamesInCoreData(completionHandler: { (result) in
            switch result {
                
            case .Success(let rootTopGames):
                response.rootTopGames = rootTopGames
                response.hasDeleted = true
                self.presenter?.presentDeletedTopGamesInCoreData(response: response)
                break
            case .Finish(let hasFinished):
                response.hasDeleted = hasFinished
                response.rootTopGames = nil
                self.presenter?.presentDeletedTopGamesInCoreData(response: response)
                break
            }
        })
    }
    
    //MARK: Methods Interactor Top Games Service
    func fetchTopGames(request: TopGames.Service.Request) {
        worker = ListTopGamesWorker(topGamesEngine: TopGamesRequester())
        var response = TopGames.Service.Response()
        
        worker?.fetchTopGames(url:request.url ?? String.loc("FIRST_10_TOP_GAMES"), completionHandler: { (result) in
            switch result{
            case .Success(let rootTopGames):
                response.rootTopGames = rootTopGames
                self.presenter?.presentFetchedTopGames(response: response)
                break
            case .Failure(let error):
                response.rootTopGames = nil
                response.requesterError = error
                self.presenter?.presentFetchedTopGames(response: response)
            }
        })
    }
}
