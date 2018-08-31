//
//  DetailTopGamePresenter.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation

protocol DetailTopGamePresentationLogic {
    func presentFetchedTopGames(response: TopGameDetail.Response)
}
class DetailTopGamePresenter: DetailTopGamePresentationLogic {
    
    weak var viewController: DetailTopGameDisplayLogic?

    //MARK: Services Methods
    func presentFetchedTopGames(response: TopGameDetail.Response) {
        var viewModel = TopGameDetail.ViewModel()
        viewModel.game = response.game
        if response.error != nil {
            viewModel.error = String.loc("NO_DETAIL_GAME")
        }
        viewController?.displayFetchedTopGames(viewModel: viewModel)
        }
}
