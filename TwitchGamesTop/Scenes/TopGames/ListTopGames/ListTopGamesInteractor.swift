//
//  ListTopGamesInteractor.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation
import CoreData

protocol ListTopGamesBusinessLogic {
    func fetchTopGames(request:TopGames.Fetch.Request)
    func saveTopGames(request: TopGames.Save.Request)
}
class ListTopGamesInteractor: ListTopGamesBusinessLogic {
   
    
    //MARK: Properties
    var presenter: ListTopGamesPresentationLogic?
    var worker: ListTopGamesWorker?
    
    //MARK: Methods Interactor Top Games
    func saveTopGames(request: TopGames.Save.Request) {
        worker = ListTopGamesWorker(topGamesEngine: TopGamesRequester())
        var response = TopGames.Fetch.Response()
        
        worker?.saveTopGamesInCoreData(url:request.nextUrl ?? String.loc("FIRST_10_TOP_GAMES"),listGames: request.listGames ?? [Games](), completionHandler: { (result) in
        
        
        })
        
    }
    
    func fetchTopGames(request: TopGames.Fetch.Request) {
        worker = ListTopGamesWorker(topGamesEngine: TopGamesRequester())
        var response = TopGames.Fetch.Response()
        
        worker?.fetchTopGames(url:request.url ?? String.loc("FIRST_10_TOP_GAMES"), completionHandler: { (result) in
            switch result{
            case .Success(let games):
                response.games = games
                self.presenter?.presentFetchedTopGames(response: response)
            case .Failure(let error):
                switch error{
                case .RequestError(let requestRrror):
                    switch requestRrror{
                    case .NoInternetAcces:
                        response.games = nil
                        response.noInternet = true
                        self.presenter?.presentFetchedTopGames(response: response)
                    default:
                        response.games = nil
                        self.presenter?.presentFetchedTopGames(response: response)
                        break
                    }
                    break
                default:
                    response.games = nil
                    self.presenter?.presentFetchedTopGames(response: response)
                    break
                }
            }
        })
    }
}
