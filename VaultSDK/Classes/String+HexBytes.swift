//
//  String+HexBytes.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/15.
//

import Foundation

extension StringProtocol {
    
    var hexBytes: [UInt8] {
        let hex = Array(self)
        let interval = 2
        return stride(from: 0, to: count, by: interval)
            .map { String(hex[$0 ..< $0 + interval]) }
            .compactMap { UInt8($0, radix: 16) }
    }
    
}
