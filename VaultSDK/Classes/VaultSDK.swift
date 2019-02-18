//
//  VaultSDK.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/15.
//

import UIKit
import AppAuth
import SwiftyJSON

enum AuthorizationResult {
    
    case success(grantCode: String, requestState: String)
    
    case error(Error?)
    
}

enum TokenExchangeResult {
    
    case success(accessToken: String)
    
    case error(Error?)
    
}

private let tokenKey = "vault_access_token_key"

private let baseURL = URL(string: "https://2019-hackathon.api.mithvault.io")!

private let authorizationEndpoint = URL(string: "https://mining.mithvault.io/zh-TW/oauth/authorize")!

private let tokenEndpoint = baseURL.appendingPathComponent("oauth")

private let userInformationEndpoint = tokenEndpoint.appendingPathComponent("user-info")

private let clientInformationEndpoint = tokenEndpoint.appendingPathComponent("balance")

private let miningEndpoint = baseURL.appendingPathComponent("mining")

public class VaultSDK: NSObject {
    
    @objc public static let shared = VaultSDK()
    
    private let clientId: String
    
    private let clientSecret: String
    
    private let miningKey: String
    
    private let redirectURL: URL
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df
    }()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    private var session: OIDExternalUserAgentSession!
    
    override init() {
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
        self.miningKey = config.miningKey
        self.redirectURL = URL(string: "vault-\(config.clientId)://oauth")!
        super.init()
    }
    
    @objc public func login(from viewController: UIViewController, callback: @escaping (String?, Error?) -> Void) {
        getUserGrantCode(viewController: viewController, callback: { [unowned self] (result) in
            switch result {
            case .success(let grantCode, let requestState):
                self.getAccessToken(grantCode: grantCode, requestState: requestState, callback: { (result) in
                    switch result {
                    case .success(let accessToken):
                        UserDefaults.standard.set(accessToken, forKey: tokenKey)
                        callback(accessToken, nil)
                    case .error(let error):
                        callback(nil, error)
                    }
                })
            case .error(let error):
                callback(nil, error)
            }
        })
    }
    
    @objc public func unbind(accessToken: String, callback: @escaping (Bool, Error?) -> Void) {
        let paylodJSON = JSON(generateDefaultPayload())
        var component = URLComponents(url: tokenEndpoint, resolvingAgainstBaseURL: true)!
        component.queryItems = paylodJSON.dictionaryValue
            .map { URLQueryItem(name: $0, value: $1.stringValue) }
        var request = URLRequest(url: component.url!)
        let signature = try! paylodJSON.signature(with: clientSecret)
        request.httpMethod = "DELETE"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(signature, forHTTPHeaderField: "X-Vault-Signature")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        URLSession.shared
            .dataTask(with: request, completionHandler: { (data, response, error) in
                if let error  = error {
                    callback(false, error)
                    return
                }
                
                UserDefaults.standard.removeObject(forKey: tokenKey)
                callback(true, nil)
            })
            .resume()
    }
    
    @objc public func getUserInformation(callback: @escaping (UserInfo?, Error?) -> Void) {
        guard let accessToken = accessToken else {
            callback(nil, VaultSDKError.notLoggedIn)
            return
        }
        
        let paylodJSON = JSON(generateDefaultPayload())
        var component = URLComponents(url: userInformationEndpoint, resolvingAgainstBaseURL: true)!
        component.queryItems = paylodJSON.dictionaryValue
            .map { URLQueryItem(name: $0, value: $1.stringValue) }
        var request = URLRequest(url: component.url!)
        let signature = try! paylodJSON.signature(with: clientSecret)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(signature, forHTTPHeaderField: "X-Vault-Signature")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        URLSession.shared
            .dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    callback(nil, error)
                    return
                }
                
                do {
                    let userInfo = try self.decoder.decode(UserInfo.self, from: data!)
                    callback(userInfo, nil)
                } catch {
                    callback(nil, VaultSDKError.failedToDecode(type: UserInfo.self, data: data!, error: error))
                }
            })
            .resume()
    }
    
    @objc public func getClientInformation(callback: @escaping ([Balance]?, Error?) -> Void) {
        guard let accessToken = accessToken else {
            callback(nil, VaultSDKError.notLoggedIn)
            return
        }
        
        let paylodJSON = JSON(generateDefaultPayload())
        var component = URLComponents(url: clientInformationEndpoint, resolvingAgainstBaseURL: true)!
        component.queryItems = paylodJSON.dictionaryValue
            .map { URLQueryItem(name: $0, value: $1.stringValue) }
        var request = URLRequest(url: component.url!)
        let signature = try! paylodJSON.signature(with: clientSecret)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(signature, forHTTPHeaderField: "X-Vault-Signature")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        URLSession.shared
            .dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    callback(nil, error)
                    return
                }
                
                do {
                    let balances = try self.decoder.decode([Balance].self, from: data!)
                    callback(balances, nil)
                } catch {
                    callback(nil, VaultSDKError.failedToDecode(type: [Balance].self, data: data!, error: error))
                }
            })
            .resume()
    }
    
    @objc public func getUserMiningAction(callback: @escaping ([MiningActivity]?, Error?) -> Void) {
        guard let accessToken = accessToken else {
            callback(nil, VaultSDKError.notLoggedIn)
            return
        }
        
        var payload = generateDefaultPayload()
        payload["mining_key"] = miningKey
        let paylodJSON = JSON(payload)
        let signature = try! paylodJSON.signature(with: clientSecret)
        var component = URLComponents(url: miningEndpoint, resolvingAgainstBaseURL: true)!
        component.queryItems = paylodJSON.dictionaryValue
            .map { URLQueryItem(name: $0, value: $1.stringValue) }
        var request = URLRequest(url: component.url!)
        request.httpMethod = "GET"
        request.setValue(signature, forHTTPHeaderField: "X-Vault-Signature")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        URLSession.shared
            .dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    callback(nil, error)
                    return
                }
                
                do {
                    let miningActivities = try self.decoder.decode([MiningActivity].self, from: data!)
                    callback(miningActivities, nil)
                } catch {
                    callback(nil, VaultSDKError.failedToDecode(type: [MiningActivity].self, data: data!, error: error))
                }
            })
            .resume()
    }
    
    @objc public func postUserMiningAction(reward: Double, uuid: String, callback: @escaping (Bool, Error?) -> Void) {
        guard let accessToken = accessToken else {
            callback(false, VaultSDKError.notLoggedIn)
            return
        }
        
        var payload = generateDefaultPayload()
        payload["mining_key"] = miningKey
        payload["uuid"] = uuid
        payload["reward"] = reward
        let timestamp = payload["timestamp"] as! Int
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let happendAt = dateFormatter.string(from: date)
        payload["happened_at"] = happendAt
        let payloadJSON = JSON(payload)
        let signature = try! payloadJSON.signature(with: clientSecret)
        var request = URLRequest(url: miningEndpoint)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(signature, forHTTPHeaderField: "X-Vault-Signature")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        URLSession.shared
            .dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    callback(false ,error)
                    return
                }
                
                let response = response as! HTTPURLResponse
                
                NSLog("🙏🙏🙏 \(String(data: data!, encoding: .utf8))")
//                if response.statusCode == 201 {
//                    callback(nil)
//                } else {
//                    callback(nil)
//                }
            })
            .resume()
    }
    
    @objc public func open(url: URL) -> Bool {
        if session.resumeExternalUserAgentFlow(with: url) {
            session = nil
            return true
        }
        
        return false
    }
    
    @objc public var isLoggedIn: Bool {
        return !(accessToken?.isEmpty ?? true)
    }
    
    @objc public var accessToken: String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    private func getUserGrantCode(viewController: UIViewController, callback: @escaping (AuthorizationResult) -> Void) {
        let configutation = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint, tokenEndpoint: tokenEndpoint)
        let request = OIDAuthorizationRequest(
            configuration: configutation,
            clientId: clientId,
            scopes: nil,
            redirectURL: redirectURL,
            responseType: "\(OIDResponseTypeCode) \(OIDResponseTypeIDToken)",
            additionalParameters: [
                "api": "https://2019-hackathon.api.mithvault.io",
                "device": "ios"
            ]
        )
        session = OIDAuthState.authState(byPresenting: request, presenting: viewController) { (state, error) in
            guard let state = state else {
                callback(.error(error))
                return
            }
            
            guard let requestState = state.lastAuthorizationResponse.request.state,
                let responseState = state.lastAuthorizationResponse.state,
                requestState == responseState else {
                    let error = VaultSDKError.stateMismatch(
                        requestState: state.lastAuthorizationResponse.request.state,
                        responseState: state.lastAuthorizationResponse.state,
                        response: state.lastAuthorizationResponse
                    )
                    callback(.error(error))
                    return
            }
            
            guard let grantCode = state.lastAuthorizationResponse.additionalParameters?["grant_code"] as? String else {
                let error = VaultSDKError.noGrantCode(response: state.lastAuthorizationResponse)
                callback(.error(error))
                return
            }
            
            callback(.success(grantCode: grantCode, requestState: requestState))
        }
    }
    
    private func getAccessToken(grantCode: String, requestState: String, callback: @escaping (TokenExchangeResult) -> Void) {
        var payload = generateDefaultPayload()
        payload["state"] = requestState
        payload["grant_code"] = grantCode
        let payloadJSON = JSON(payload)
        let signature = try! payloadJSON.signature(with: clientSecret)
        var request = URLRequest(url: tokenEndpoint)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(signature, forHTTPHeaderField: "X-Vault-Signature")
        URLSession.shared
            .dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    callback(.error(error))
                    return
                }
                
                do {
                    let tokenWrapper = try self.decoder.decode(TokenWrapper.self, from: data!)
                    callback(.success(accessToken: tokenWrapper.token))
                } catch {
                    callback(.error(VaultSDKError.failedToDecode(type: TokenWrapper.self, data: data!, error: error)))
                }
            })
            .resume()
    }
    
    private func generateDefaultPayload() -> [String: Any] {
        return [
            "client_id": clientId,
            "timestamp": Int(Date().timeIntervalSince1970),
            "nonce": Data(secRandonBytesCount: 32)?.uInt as Any
        ]
    }
    
}
