//
//  Token.swift
//  SocialSports
//
//  Created by lengly on 15/10/16.
//  Copyright © 2015年 lengly. All rights reserved.
//

import UIKit

class Token: NSObject, NSCoding {
    
    // MARK: Properties
    var token: String
    static let tokenKey = "token"
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("token")
    
    // MARK: Initialization
    init?(token: String) {
        self.token = token
        super.init()
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(token, forKey: Token.tokenKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let token = aDecoder.decodeObjectForKey(Token.tokenKey) as! String
        
        // Must call designated initializer.
        self.init(token: token)
    }
}
