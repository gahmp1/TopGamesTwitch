//
//  DetailTopGameInteractor.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation
import CoreData

protocol DetailTopGameBusinessLogic {
    func fetchDetailTopGame(request:TopGameDetail.Request)
}
class DetailTopGameInteractor: DetailTopGameBusinessLogic {
   
    
    //MARK: Properties
    var presenter: DetailTopGamePresentationLogic?
    var worker: DetailTopGameWorker?
    

    //MARK: Methods Interactor Top Games Core Data
    func fetchDetailTopGame(request: TopGameDetail.Request) {
        worker = DetailTopGameWorker(topGamesEngine: DetailTopGameRequester())
        var response = TopGameDetail.Response()
        if let game = request.game {
            worker?.fetchTopGames(game: game, completionHandler: { (result) in
                switch result {
                    
                case .Success(let games):
                    response.games = games
                    self.presenter?.presentFetchedTopGames(response: response)
                    break
                case .Failure(let error):
                    response.games = nil
                    response.error = error
                    self.presenter?.presentFetchedTopGames(response: response)
                }
            })
        }
    }
}
