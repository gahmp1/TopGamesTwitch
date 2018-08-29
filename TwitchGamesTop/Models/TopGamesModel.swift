//
//  TopGames.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//


struct Games:Codable,Equatable {
    
    var channels: Int
    var viewers: Int
    var game: Game

}

struct Game:Codable,Equatable {
    var name: String
    var logo: Logo
    var box: Box
}

struct Logo:Codable,Equatable
{
    var large:String
    var medium:String
    var small:String
    var template:String
}

struct Box:Codable,Equatable
{
    var large:String
    var medium:String
    var small:String
    var template:String
}

struct Links:Codable,Equatable
{
    var next:String
}

// MARK: - Parse Top Games model
struct RootTopGames:Codable,Equatable
{
    var _links: Links
    var _total: Int
    var top:[Games]
}


