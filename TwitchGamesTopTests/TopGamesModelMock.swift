//
//  TwitchGamesTopTests.swift
//  TwitchGamesTopTests
//
//  Created by Banco Santander Brasil on 30/08/18.
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//
@testable import TwitchGamesTop
import XCTest

struct Mock {
    struct GameMock {
        static let firstGame = Game(channels: 11, viewers: 3232322, game: GameInfoMock.firstGameInfo)
        static let secondGame = Game(channels: 10, viewers: 20000, game: GameInfoMock.firstGameInfo)
    }
    
    struct GameInfoMock{
        static let firstGameInfo = GameInfo(name: String.loc("NO_GAME_NAME"), image: "", logo: LogoMock.firstLogo)
    }
    
    struct LogoMock {
        static let firstLogo = Logo(large: String.loc("DEFAULT_URL_IMAGE"))
    }
    
    struct LinksMock {
        static let firstLink = Links(next: String.loc("FIRST_10_TOP_GAMES"))
    }
    
    struct RootTopGamesMock {
        static let fistRootTopGamesMock = RootTopGames(_links: LinksMock.firstLink, top: [GameMock.firstGame,GameMock.secondGame])
    }
}

//
//struct Logo:Codable,Equatable
//{
//    var large:String
//}
//
//
//struct Links:Codable,Equatable
//{
//    var next:String
//}
//
//// MARK: - Parse Top Games model
//struct RootTopGames:Codable,Equatable
//{
//    var _links: Links
//    var top:[Games]
//}
