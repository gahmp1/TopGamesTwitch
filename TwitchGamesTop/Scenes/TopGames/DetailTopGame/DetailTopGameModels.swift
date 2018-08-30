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
        var game: Games?
    }
    struct Response
    {
        var error : DetailTopGameWorkerError?
        var games: Games?
    }
    struct ViewModel
    {
        var error : String?
        var games: Games?
    }
}
