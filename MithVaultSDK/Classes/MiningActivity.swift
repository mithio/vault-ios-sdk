//
//  MiningActivity.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/18.
//

import Foundation

@objc public class MiningActivity: NSObject, Codable {
    
    @objc public let amount: Double
    
    @objc public let reward: Double
    
    @objc public let happendAt: Date
    
    @objc public let updatedAt: Date
    
    @objc public let status: String
    
    @objc public let uuid: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case reward
        case happendAt
        case updatedAt
        case status
        case uuid
    }
    
    public override var debugDescription: String {
        let data = try! JSONEncoder().encode(self)
        return String(data: data, encoding: .utf8)!
    }
    
    public override var description: String {
        let data = try! JSONEncoder().encode(self)
        return String(data: data, encoding: .utf8)!
    }
    
}
