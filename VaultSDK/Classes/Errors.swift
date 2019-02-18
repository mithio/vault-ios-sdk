//
//  Errors.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/15.
//

import Foundation
import AppAuth

struct StateMismatchError: Error, LocalizedError {
    
    let requestState: String?
    
    let responseState: String?
    
    let response: OIDAuthorizationResponse
    
    var errorDescription: String? {
        return "State mismatch, expecting \(String(describing: requestState)) but got \(String(describing: responseState)) in authorization esponse \(response)"
    }
    
}

struct NoGrantCodeError: Error, LocalizedError {
    
    let response: OIDAuthorizationResponse
    
    var errorDescription: String? {
        return "No grant code, expecting grant_code in redirect URL. Authroization response: \(response)"
    }
    
}

struct NoTokenError: Error, LocalizedError {
    
    var errorDescription: String? {
        return "Expecting \"token\" in json response"
    }
    
}

struct NotLoggedInError: Error, LocalizedError {
    
    var errorDescription: String? {
        return "Please log in first"
    }
    
}
