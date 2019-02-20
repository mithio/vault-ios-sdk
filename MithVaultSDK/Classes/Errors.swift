//
//  Errors.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/15.
//

import Foundation
import AppAuth

enum VaultSDKError: Error, LocalizedError {
    
    case stateMismatch(requestState: String?, responseState: String?, response: OIDAuthorizationResponse)
    
    case noGrantCode(response: OIDAuthorizationResponse)
    
    case failedToDecode(type: Decodable.Type, data: Data, error: Error)
    
    case serverErrorCode(String)
    
    case notLoggedIn
    
    var errorDescription: String? {
        switch (self) {
        case .stateMismatch(let requestState, let responseState, let response):
            return "State mismatch, expecting \(String(describing: requestState)) but got \(String(describing: responseState)) in authorization esponse \(response)"
        case .noGrantCode(let response):
            return "No grant code, expecting grant_code in redirect URL. Authroization response: \(response)"
        case .failedToDecode(let type, let data, let error):
            return "Failed to decode, expecting \(type) object, but got \(String(data: data, encoding: .utf8) ?? "empty response body"). JSONDecoder error: \(error) "
        case .serverErrorCode(let errorCode):
            return "Server error code, \(errorCode)"
        case .notLoggedIn:
            return "No access token. Log in before calling any other api."
        }
    }
    
}
