//
//  TopGamesViewModels.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation

// MARK: Use cases

enum TopGames
{
    enum Fetch {
        struct Request
        {
            var url:String?
        }
        struct Response
        {
            var games:RootTopGames?
            var noInternet:Bool = false
        }
        struct ViewModel
        {
            var games:RootTopGames?
            
            var alertTitle:String?
            var alertMessage:String?
        }
    }
    
    enum Save {
        struct Request
        {
            var nextUrl: String?
            var listGames: [Games]?
        }
        struct Response
        {
        }
        struct ViewModel
        {
            var games:RootTopGames?
        }
    }
}
