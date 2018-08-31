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
        var message = String.loc("SAVED_UPDATED_CORE_DATA_ALERT_MESSAGE")
        
        if response.hasFinished == false {
            message = String.loc("NOT_SAVED_UPDATED_CORE_DATA_ALERT_MESSAGE")
        }
        viewModel.alertMessage = message
        viewModel.rootTopGames = response.rootTopGames
        viewController?.displaySavedUpdateTopGamesCoreData(viewModel: viewModel)
    }
    
    func presentFetchedTopGamesInCoreData(response: TopGames.CoreData.Fetch.Response) {
        var viewModel = TopGames.CoreData.Fetch.ViewModel()
        var message = String.loc("FETCHED_CORE_DATA_ALERT_MESSAGE")
        
        if response.hasFinished == false {
            message = String.loc("NOT_FETCHED_CORE_DATA_ALERT_MESSAGE")
        }
        viewModel.alertMessage = message
        viewModel.rootTopGames = response.rootTopGames
        viewController?.displayFetchedTopGamesCoreData(viewModel: viewModel)
    }
    
    func presentDeletedTopGamesInCoreData(response: TopGames.CoreData.Delete.Response) {
        var viewModel = TopGames.CoreData.Delete.ViewModel()
        var message = String.loc("DELETED_CORE_DATA_ALERT_MESSAGE")
        
        if response.hasDeleted == false {
            message = String.loc("NOT_DELETED_CORE_DATA_ALERT_MESSAGE")
        }
        viewModel.alertMessage = message
        viewModel.rootTopGames = response.rootTopGames
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
            viewModel.rootTopGames = response.rootTopGames
            viewController?.displayFetchedTopGames(viewModel: viewModel)
            
        }
    }
    
}
