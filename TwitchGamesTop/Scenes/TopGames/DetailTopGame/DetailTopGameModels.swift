//
//  TopGameDetailViewModels.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation

// MARK: Use cases

enum TopGameDetail
{
    struct Request
    {
        var game: Game?
    }
    struct Response
    {
        var error : DetailTopGameWorkerError?
        var game: Game?
    }
    struct ViewModel
    {
        var error : String?
        var game: Game?
    }
}
