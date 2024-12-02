//
//  KeychainHelper.swift
//  Stay_Connected_App
//
//  Created by Sandro Maraneli on 02.12.24.
//

import UIKit
import KeychainSwift

public class KeychainHelper {
    static let keychain = KeychainSwift()
    
    static func saveAccessToken(_ token: String) {
        keychain.set(token, forKey: "access_token")
    }
    
    static func saveRefreshToken(_ token: String) {
        keychain.set(token, forKey: "refresh_token")
    }
    
    static func getAccessToken() -> String? {
        return keychain.get("access_token")
    }
    
    static func getRefreshToken() -> String? {
        return keychain.get("refresh_token")
    }
    
    static func deleteTokens() {
        keychain.delete("access_token")
        keychain.delete("refresh_token")
    }
}
