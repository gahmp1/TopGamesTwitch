//
//  TopGames.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//


struct Game:Codable,Equatable {
    
    var channels: Int
    var viewers: Int
    var game: GameInfo?
    
//    init(channels:Int, viewers:Int, gameInfo:GameInfo) {
//        self.channels = channels
//        self.viewers = viewers
//        self.game = gameInfo
//    }

}

struct GameInfo:Codable,Equatable {
    var name: String
    var image: String?
    var logo: Logo
    
//    init(name:String, image:String, logo:Logo) {
//        self.name = name
//        self.image = image
//        self.logo = logo
//    }

}

struct Logo:Codable,Equatable
{
    var large:String
    
//    init(large:String) {
//        self.large = large
//    }
    
}


struct Links:Codable,Equatable
{
    var next:String
    
//    init(next:String) {
//        self.next = next
//    }
}

// MARK: - Parse Top Games model
struct RootTopGames:Codable,Equatable
{
    var _links: Links
    var top:[Game]
    
//    init(links:Links, topGames: [Game]) {
//        self._links = links
//        self.top = topGames
//    }
}


