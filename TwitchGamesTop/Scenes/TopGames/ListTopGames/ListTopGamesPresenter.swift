//
//  ListTopGamesPresenter.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation

protocol ListTopGamesPresentationLogic {
    func presentSavedUpdatedTopGamesInCoreData(response: TopGames.CoreData.SaveUpdate.Response)
    func presentFetchedTopGamesInCoreData(response: TopGames.CoreData.Fetch.Response)
    func presentDeletedTopGamesInCoreData(response: TopGames.CoreData.Delete.Response)
    func presentFetchedTopGames(response: TopGames.Service.Response)
}
class ListTopGamesPresenter: ListTopGamesPresentationLogic {
    
    weak var viewController: ListTopGamesDisplayLogic?
    
    //MARK: Core Data Methods
    func presentSavedUpdatedTopGamesInCoreData(response: TopGames.CoreData.SaveUpdate.Response) {
        var viewModel = TopGames.CoreData.SaveUpdate.ViewModel()
        if response.hasFinished == false {
            let title = String.loc("NO_INTERNET_ACCESS_ALERT_TITLE")
            let message = String.loc("NO_INTERNET_ACCESS_ALERT_MESSAGE")
            
            viewModel.alertTitle = title
            viewModel.alertMessage = message
        }
        viewModel.games = response.games
        viewController?.displaySavedUpdateTopGamesCoreData(viewModel: viewModel)
    }
    
    func presentFetchedTopGamesInCoreData(response: TopGames.CoreData.Fetch.Response) {
        var viewModel = TopGames.CoreData.Fetch.ViewModel()
        if response.hasFinished == false {
            let title = String.loc("NO_INTERNET_ACCESS_ALERT_TITLE")
            let message = String.loc("NO_INTERNET_ACCESS_ALERT_MESSAGE")
            
            viewModel.alertTitle = title
            viewModel.alertMessage = message
        }
        viewModel.games = response.games
        viewController?.displayFetchedTopGamesCoreData(viewModel: viewModel)
    }
    
    func presentDeletedTopGamesInCoreData(response: TopGames.CoreData.Delete.Response) {
        var viewModel = TopGames.CoreData.Delete.ViewModel()
        if response.hasDeleted == false {
            let title = String.loc("NO_INTERNET_ACCESS_ALERT_TITLE")
            let message = String.loc("NO_INTERNET_ACCESS_ALERT_MESSAGE")
            
            viewModel.alertTitle = title
            viewModel.alertMessage = message
        }
        viewModel.games = response.games
        viewController?.displayDeletedTopGamesCoreData(viewModel: viewModel)
    }
    
    
    
    //MARK: Services Methods
    func presentFetchedTopGames(response: TopGames.Service.Response) {
        var viewModel = TopGames.Service.ViewModel()
        
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
