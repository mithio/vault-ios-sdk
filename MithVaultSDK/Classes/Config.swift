//
//  Config.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/15.
//

import Foundation

struct Config: Decodable {
    
    let clientId: String
    
    let clientSecret: String
    
    let miningKey: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "ClientId"
        case clientSecret = "ClientSecret"
        case miningKey = "MiningKey"
    }
    
}
