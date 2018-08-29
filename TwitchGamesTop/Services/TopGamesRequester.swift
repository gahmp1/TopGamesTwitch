//
//  TopGamesRequester.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class TopGamesRequester: ListTopGamesWorkerLogic {
    func fetchTopGamesInCoreData() {
        
    }
    func saveTopGamesInCoreData(url: String, listGames: [Games], completionHandler: @escaping FetchTopGamesCompletionHandler) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            if let topGamesCoredataDescription = NSEntityDescription.entity(forEntityName: "TopGamesCoredata", in: managedObjectContext) {
                let topGamesCoredata = TopGamesCoredata.init(entity: topGamesCoredataDescription, insertInto: managedObjectContext)
                topGamesCoredata.nextUrl = url
                for game in listGames {
                    if let gameCoredataDescription = NSEntityDescription.entity(forEntityName: "GameCoredata", in: managedObjectContext) {
                        let gameCoreData = GameCoredata(entity: gameCoredataDescription, insertInto: managedObjectContext)
                        gameCoreData.channels = Int64(game.channels)
                        gameCoreData.viewers = Int64(game.viewers)
                        //gameCoreData.image = game.
                        gameCoreData.name = game.game?.name ?? String.loc("NO_GAME_NAME")
                        topGamesCoredata.addToGames(gameCoreData)
                    }
                }
                print(topGamesCoredata)
            }
        }
    }
    
    func fetchTopGames(url:String, completionHandler: @escaping FetchTopGamesCompletionHandler) {
        
        guard let url = URL(string: url) else {
            
            completionHandler(TopGamesWorkerResult.Failure(error: TopGamesWorkerError.RequestError(RequesterError.WrongURLFormat)))
            return
        }
        
        let headers : HTTPHeaders = ["Client-ID": "426elxfoq1u2l77a10fu6ull62z1da"]
        
        Alamofire.request(url,
                          method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    if let error = response.result.error {
                        print("Error while fetching Top Games: \(String(describing: error))")
                        completionHandler(TopGamesWorkerResult.Failure(error: TopGamesWorkerError.RequestError(RequesterError.CannotFetch(error))))
                    }
                    return
                }
                
                guard let data = response.data  else {
                        print("Malformed data received from fetchTopGames service")
                        completionHandler(TopGamesWorkerResult.Failure(error: TopGamesWorkerError.ParseError))
                        return
                }
                if let parsedCell = self.parseCell(data: data) {
                    completionHandler(TopGamesWorkerResult.Success(result: parsedCell))
                } else {
                    completionHandler(TopGamesWorkerResult.Failure(error: TopGamesWorkerError.ParseError))
                }
                
            
        }
    }
    
    private func parseCell(data: Data) -> RootTopGames?{
        do{

            let topGamesRoot = try JSONDecoder().decode(RootTopGames.self, from: data)
            return topGamesRoot
        } catch{
            return nil
        }
    }
    

}
