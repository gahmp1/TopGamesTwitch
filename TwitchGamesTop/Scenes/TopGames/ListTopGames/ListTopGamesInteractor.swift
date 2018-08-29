//
//  ListTopGamesInteractor.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation

protocol ListTopGamesBusinessLogic {
    func fetchTopGames(request:TopGames.Request)
}
class ListTopGamesInteractor: ListTopGamesBusinessLogic {
    
    //MARK: Properties
    var presenter: ListTopGamesPresentationLogic?
    var worker: ListTopGamesWorker?
    
    //MARK: Fetch Top Games
    func fetchTopGames(request: TopGames.Request) {
        worker = ListTopGamesWorker(topGamesEngine: TopGamesRequester())
        var response = TopGames.Response()
        
        worker?.fetchTopGames(url:request.url ?? "https://api.twitch.tv/kraken/games/top?limit=10&offset=0", completionHandler: { (result) in
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
