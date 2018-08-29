//
//  TopGames.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//


struct Games:Codable,Equatable {
    
    var channels: Int
    var viewers: Int
    var game: Game?

}

struct Game:Codable,Equatable {
    var name: String
    var logo: Logo

}

struct Logo:Codable,Equatable
{
    var large:String
}


struct Links:Codable,Equatable
{
    var next:String
}

// MARK: - Parse Top Games model
struct RootTopGames:Codable,Equatable
{
    var _links: Links
    var top:[Games]
}


