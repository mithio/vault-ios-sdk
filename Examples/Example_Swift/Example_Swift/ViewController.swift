//
//  ViewController.swift
//  Example_Swift
//
//  Created by Alex Huang on 2019/2/20.
//  Copyright © 2019 Mithril Ltd. All rights reserved.
//

import UIKit
import MithVaultSDK

class ViewController: UIViewController {

    @IBOutlet weak var loginWithVaultButton: UIButton!
    @IBOutlet weak var getUserInfoButton: UIButton!
    @IBOutlet weak var getClientInfoButton: UIButton!
    @IBOutlet weak var getUserMiningActionButton: UIButton!
    @IBOutlet weak var postUserMiningActionButton: UIButton!
    @IBOutlet weak var rewardTextField: UITextField! {
        didSet {
            rewardTextField.placeholder = "0.12345678"
            rewardTextField.keyboardType = .decimalPad
        }
    }
    @IBOutlet weak var unbindVaultButton: UIButton!
    @IBOutlet weak var consoleTextView: UITextView! {
        didSet {
            if MithVaultSDK.shared.isLoggedIn {
                consoleTextView.text = "User is already logged in with access token, \(MithVaultSDK.shared.accessToken!).\n\n"
            } else {
                consoleTextView.text = "Please log in with VAULT.\n\n"
            }
            consoleTextView.isEditable = false
            consoleTextView.layer.borderWidth = 0.5
            consoleTextView.layer.cornerRadius = 8
            consoleTextView.layer.borderColor = UIColor.black.cgColor
            consoleTextView.keyboardDismissMode = .interactive
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        let isLoggedIn = MithVaultSDK.shared.isLoggedIn
        loginWithVaultButton.isEnabled = !isLoggedIn
        getUserInfoButton.isEnabled = isLoggedIn
        getClientInfoButton.isEnabled = isLoggedIn
        getUserMiningActionButton.isEnabled = isLoggedIn
        postUserMiningActionButton.isEnabled = isLoggedIn
        rewardTextField.isEnabled = isLoggedIn
        unbindVaultButton.isEnabled = isLoggedIn
    }

    @IBAction func loginWithVault(_ sender: UIButton) {
        MithVaultSDK.shared.login(from: self) { (token, error) in
            guard let token = token else {
                self.consoleTextView.text += "\(error!.localizedDescription)\n\n"
                return
            }
            
            self.updateUI()
            self.consoleTextView.text += "Successfully logged in, got access token, \(token).\n\n"
        }
    }
    
    @IBAction func getUserInfo(_ sender: UIButton) {
        MithVaultSDK.shared.getUserInformation { (userInfo, error) in
            guard let userInfo = userInfo else {
                self.consoleTextView.text += "\(error!.localizedDescription)\n\n"
                return
            }
            
            self.consoleTextView.text += "User information: \(userInfo)\n\n"
        }
    }
    
    @IBAction func getClinetInfo(_ sender: UIButton) {
        MithVaultSDK.shared.getClientInformation { (balances, error) in
            guard let balances = balances else {
                self.consoleTextView.text += "\(error!.localizedDescription)\n\n"
                return
            }
            
            self.consoleTextView.text += "Client information: \(balances)\n\n"
        }
    }
    
    @IBAction func getUserMingingAction(_ sender: UIButton) {
        MithVaultSDK.shared.getUserMiningAction { (miningActivities, error) in
            guard let miningActivities = miningActivities else {
                self.consoleTextView.text += "\(error!.localizedDescription)\n\n"
                return
            }
            
            self.consoleTextView.text += "Mining activities: \(miningActivities)\n\n"
        }
    }
    
    @IBAction func postUserMiningAction(_ sender: UIButton) {
        guard let reward = Double(rewardTextField.text ?? "") else {
            self.consoleTextView.text += "Please fill a number in the reward text field.\n\n"
            return
        }
        
        MithVaultSDK.shared.postUserMiningAction(reward: reward, uuid: UUID().uuidString) { (success, error) in
            guard success else {
                self.consoleTextView.text += "\(error!.localizedDescription)\n\n"
                return
            }
            
            self.rewardTextField.resignFirstResponder()
            self.rewardTextField.text = nil
            self.consoleTextView.text += "Successfully post user mining action with reward, \(reward).\n\n"
        }
        
    }
    
    @IBAction func unbindVault(_ sender: UIButton) {
        let accessToken = MithVaultSDK.shared.accessToken!
        MithVaultSDK.shared.unbind { (success, error) in
            guard success else {
                self.consoleTextView.text += "\(error!.localizedDescription)\n\n"
                return
            }
            
            self.updateUI()
            self.consoleTextView.text += "Successfully unbind access token, \(accessToken).\n\n"
        }
    }
    
    @IBAction func clearConsole(_ sender: UIButton) {
        consoleTextView.text = ""
    }
    
}

