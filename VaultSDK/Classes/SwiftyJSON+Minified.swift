//
//  SwiftyJSON+Minified.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/15.
//

import Foundation
import SwiftyJSON
import CryptoSwift

extension JSON {
    
    var minified: String {
        if let dictionary = dictionary {
            return dictionary
                .sorted { $0.key < $1.key }
                .map { "\($0)=\($1.minified)" }
                .joined(separator: "&")
        } else if let array = array {
            let str = array
                .map { $0.minified }
                .joined(separator: ",")
            return "[\(str)]"
        } else {
            return stringValue
        }
    }
    
    func signature(with key: String) throws -> String {
        return try HMAC(key: key.hexBytes, variant: .sha512)
            .authenticate(minified.bytes)
            .toHexString()
    }
    
}
