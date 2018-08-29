//
//  TopGamesRequester.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation
import Alamofire
class TopGamesRequester: ListTopGamesWorkerLogic {
    
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
