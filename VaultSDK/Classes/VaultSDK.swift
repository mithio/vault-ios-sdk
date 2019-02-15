//
//  VaultSDK.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/15.
//

import UIKit

public class VaultSDK: NSObject {
    
    private let clientId: String
    
    private let clientSecret: String
    
    private let redirectURL: URL
    
    public override init() {
        guard let url = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            fatalError()
        }
        
        guard let data = try? Data(contentsOf: url)  else {
            fatalError()
        }
        
        guard let config = try? PropertyListDecoder().decode(Config.self, from: data) else {
            fatalError()
        }
        
        self.clientId = config.clientId
        self.clientSecret = config.clientSecret
        self.redirectURL = URL(string: "vault-\(config.clientId)://oauth")!
        super.init()
    }
    
}
