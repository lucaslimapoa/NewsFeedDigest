//
//  CoordinatorProtocol.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/8/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import Foundation
import UIKit

@objc protocol Coordinator {
    var children: [Coordinator] { get }    
    func start()
}
