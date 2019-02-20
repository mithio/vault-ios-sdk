//
//  Data+SecRandomBytesCount.swift
//  AppAuth
//
//  Created by Alex Huang on 2019/2/15.
//

import Foundation

extension Data {
    
    public init?(secRandonBytesCount bytesCount: Int) {
        var bytes = [UInt8](repeating: 0, count: bytesCount)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytesCount, &bytes)
        guard status == errSecSuccess else {
            return nil
        }
        
        self.init(bytes: bytes)
    }
    
    var uInt: UInt {
        return UInt(bigEndian: withUnsafeBytes { $0.pointee })
    }
    
}
