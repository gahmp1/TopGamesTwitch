//
//  DetailTopGameRequester.swift
//  TwitchGamesTop
//
//  Created by Banco Santander Brasil on 29/08/18.
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation

class DetailTopGameRequester: DetailTopGameWorkerLogic {
    func fetchDetailTopGame(game: Game, completionHandler: @escaping FetchDetailTopGameCompletionHandler) {
        completionHandler(DetailTopGameWorkerResult.Success(result: game))
    }

}
