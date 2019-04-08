//
//  UserInformation.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/18.
//

import Foundation

@objc public class UserInfo: NSObject, Codable {
    
    @objc public let amount: Double
    
    @objc public let balance: Double
    
    @objc public let kycLevel: Int
    
    @objc public let stakeLevel: Int
    
    @objc public let stakedAmount: Double
    
    enum CodingKeys: String, CodingKey {
        case amount
        case balance
        case kycLevel
        case stakeLevel
        case stakedAmount
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
