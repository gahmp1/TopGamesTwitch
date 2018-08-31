//
//  TopGamesRequester.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class TopGamesRequester: ListTopGamesWorkerLogic {

    //MARK: CoreData
    func saveUpdateTopGamesInCoreData(url: String, listGames: [Game], completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler) {
        checkTopGamesInCoreData(url: url, listGames: listGames, completionHandler: completionHandler)
    }
    
    func checkTopGamesInCoreData(url: String, listGames: [Game], completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler) {
        let _ = hasDeletedTopGames()
        saveTopGamesInCoreData(url: url, listGames: listGames, completionHandler: completionHandler)

    }
    
    func fetchTopGamesInCoreData(completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler) {
        if let topGamesCoredata = findTopGamesInCoreData() {
            if let rootTopGames = convertCoreDataToRootTopGames(topGamesCoredata: topGamesCoredata) {
                completionHandler(TopGamesCoreDataWorkerResult.Success(result: rootTopGames))
                return
            }
            completionHandler(TopGamesCoreDataWorkerResult.Finish(hasFinished: false))
        } else {
            completionHandler(TopGamesCoreDataWorkerResult.Finish(hasFinished: false))
        }
    }
    
    func deleteTopGamesInCoreData(completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler) {
        completionHandler(TopGamesCoreDataWorkerResult.Finish(hasFinished: hasDeletedTopGames()))
    }
    
    private func saveTopGamesInCoreData(url: String, listGames: [Game], completionHandler: @escaping FetchTopGamesCoreDataCompletionHandler) {
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
                        gameCoreData.logoLarge = game.game?.logo.large
                        gameCoreData.image = game.game?.image
                        gameCoreData.name = game.game?.name ?? String.loc("NO_GAME_NAME")
                        topGamesCoredata.addToGames(gameCoreData)
                    }
                }
                do {
                    try managedObjectContext.save()
                    if let rootTopGames = convertCoreDataToRootTopGames(topGamesCoredata: topGamesCoredata) {
                        completionHandler(TopGamesCoreDataWorkerResult.Success(result: rootTopGames))
                        return
                    }
                    completionHandler(TopGamesCoreDataWorkerResult.Finish(hasFinished: false))
                } catch {
                    print("Failed saving Top Games")
                    completionHandler(TopGamesCoreDataWorkerResult.Finish(hasFinished: false))
                    
                }
            }
        }
    }
    
    private func convertCoreDataToRootTopGames (topGamesCoredata: TopGamesCoredata) -> RootTopGames? {
        var topGames = [Game]()
        for gameCoreData in (topGamesCoredata.games!.allObjects as? [GameCoredata])! {
            let game = GameInfo(name: gameCoreData.name ?? String.loc("NO_GAME_NAME"), image: gameCoreData.image ?? "", logo: Logo(large: gameCoreData.logoLarge ?? String.loc("DEFAULT_URL_IMAGE")))
            let games = Game(channels: Int(gameCoreData.channels), viewers: Int(gameCoreData.viewers), game: game)
            topGames.append(games)
        }
        let rootTopGames = RootTopGames(_links: Links(next: topGamesCoredata.nextUrl!), top: topGames)
        return rootTopGames
    }
    
    private func findTopGamesInCoreData() -> TopGamesCoredata? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TopGamesCoredata")
        request.returnsObjectsAsFaults = false
        do {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let managedObjectContext = appDelegate.persistentContainer.viewContext
                if let topGamesCoredata = try managedObjectContext.fetch(request).first as? TopGamesCoredata {
                    return topGamesCoredata
                }
                return nil
            }
            
        } catch {
            print("Failed fetching Top Games")
            return nil
        }
        return nil
    }
    
    private func hasDeletedTopGames() -> Bool {
        if let topGamesCoredata = findTopGamesInCoreData() {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let managedObjectContext = appDelegate.persistentContainer.viewContext
                managedObjectContext.delete(topGamesCoredata)
                return topGamesCoredata.isDeleted
            }
        }
        return false
    }
    
    
    //MARK: Services
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
