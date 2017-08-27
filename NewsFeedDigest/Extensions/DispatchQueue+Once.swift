//
//  DispatchQueue+Once.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 8/25/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    private static var dispatchTokens = [String]()
    
    public static func once(token: String, completion: () -> Void) {
        guard !dispatchTokens.contains(token) else { return }
        
        dispatchTokens.append(token)
        
        completion()
    }
    
}
