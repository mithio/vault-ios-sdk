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

