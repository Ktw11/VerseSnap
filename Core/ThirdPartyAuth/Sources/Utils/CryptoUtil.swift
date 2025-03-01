//
//  CryptoUtil.swift
//  Authentication
//
//  Created by 공태웅 on 3/1/25.
//

import Foundation
import CryptoKit

enum CryptoUtil {
    
    // MARK: Properties
    
    static let charSet: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    
    // MARK: Methods
    
    static func makeRandomNonce(count: Int = 32) -> String {
        precondition(count > 0)
        
        var randomBytes = [UInt8](repeating: 0, count: count)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        
        guard errorCode == errSecSuccess else { fatalError() }
        
        let nonce = randomBytes.map { byte in
            charSet[Int(byte) % charSet.count]
        }
        
        return String(nonce)
    }
    
    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        
        return hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
    }
}
