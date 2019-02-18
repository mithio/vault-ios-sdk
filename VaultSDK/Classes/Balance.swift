//
//  Balance.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/18.
//

import Foundation

@objc public class Balance: NSObject, Codable {
    
    @objc public let currency: String
    
    @objc public let balance: Double
    
    @objc public let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case currency
        case balance
        case updatedAt = "updated_at"
    }
    
}

