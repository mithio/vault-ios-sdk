//
//  ViewController.swift
//  Example_Swift
//
//  Created by Alex Huang on 2019/2/15.
//  Copyright © 2019 Mithril Ltd. All rights reserved.
//

import UIKit
import VaultSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if VaultSDK.shared.isLoggedIn {
            VaultSDK.shared.getUserInformation { (userInfo, error) in
                guard let userInfo = userInfo else {
                    NSLog("\(error)")
                    return
                }
                
                NSLog("\(userInfo)")
            }
            
            VaultSDK.shared.getClientInformation { (balances, error) in
                guard let balances = balances else {
                    NSLog("\(error)")
                    return
                }
                
                NSLog("\(balances)")
            }
            
            VaultSDK.shared.getUserMiningAction { (miningActivities, error) in
                guard let miningActivities = miningActivities else {
                    NSLog("\(error)")
                    return
                }
                
                NSLog("\(miningActivities)")
            }
            
            VaultSDK.shared.postUserMiningAction(reward: 123.789, uuid: UUID().uuidString) { (success, error) in
                NSLog("\(success)")
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                VaultSDK.shared.login(from: self) { (token, error) in
                    guard let token = token else {
                        NSLog("\(error)")
                        return
                    }
                    
                    NSLog(token)
                }                
            }
        }
    }


}

