//
//  Helper.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/15.
//

import Foundation
import SwiftyJSON
import CryptoSwift

func signature(payload: [String: Any], key: String) throws -> String {
    let json = JSON(payload)
    return try HMAC(key: key.hexBytes, variant: .sha512)
        .authenticate(json.minified.bytes)
        .toHexString()
}

func signature(payload: [Any], key: String) throws -> String {
    let json = JSON(payload)
    return try HMAC(key: key.hexBytes, variant: .sha512)
        .authenticate(json.minified.bytes)
        .toHexString()
}
