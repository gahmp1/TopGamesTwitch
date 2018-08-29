//
//  String+Extensions.swift
//  TwitchGamesTop
//
//  Created by Banco Santander Brasil on 28/08/18.
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import Foundation


extension String{
    
    
    static func loc(_ loc:String) -> String{
        var result = Bundle.main.localizedString(forKey: loc, value: nil, table: nil)
        
        if result == loc {
            result = Bundle.main.localizedString(forKey: loc, value: nil, table: "TopGamesLocalizable")
        }
        return result
    }
    
}
