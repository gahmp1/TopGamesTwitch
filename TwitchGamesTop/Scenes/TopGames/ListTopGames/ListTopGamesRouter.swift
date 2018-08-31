//
//  ListTopGamesRouter.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation
import UIKit
protocol ListTopGamesRoutingLogic {
    func routeToDetailTopGame(game:Game)
}
class ListTopGamesRouter:NSObject, ListTopGamesRoutingLogic {
    weak var viewController: ListTopGamesViewController?
    
    //MARK: Routing
    func routeToDetailTopGame(game:Game) {
        let storyboard = UIStoryboard(name: "TopGames", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "DetailTopGameViewController") as? DetailTopGameViewController {
            controller.game = game
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}



