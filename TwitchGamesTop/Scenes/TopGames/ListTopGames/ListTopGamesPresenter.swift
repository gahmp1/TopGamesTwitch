//
//  ListTopGamesPresenter.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation

protocol ListTopGamesPresentationLogic {
    func presentFetchedTopGames(response: TopGames.Fetch.Response)
}
class ListTopGamesPresenter: ListTopGamesPresentationLogic {
    
    weak var viewController: ListTopGamesDisplayLogic?
    
    func presentFetchedTopGames(response: TopGames.Fetch.Response) {
        var viewModel = TopGames.Fetch.ViewModel()
        
        if response.noInternet{
            let title = String.loc("NO_INTERNET_ACCESS_ALERT_TITLE")
            let message = String.loc("NO_INTERNET_ACCESS_ALERT_MESSAGE")
            
            viewModel.alertTitle = title
            viewModel.alertMessage = message
            
            viewController?.displayFetchedTopGames(viewModel: viewModel)
        } else{
            
            
            viewModel.games = response.games
            viewController?.displayFetchedTopGames(viewModel: viewModel)
            
        }
    }
    
}
