//
//  TokenLocation.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/11.
//

import Foundation

public struct TokenLocation:Hashable
    {
    public let start:Int
    public let stop:Int
    
    init(token:Token)
        {
        let location = token.location
        self.init(start:location.tokenStart,stop:location.tokenStop)
        }
        
    init(start:Int,stop:Int)
        {
        self.start = start
        self.stop = stop
        }
        
    public func hash(into hasher: inout Hasher)
        {
        hasher.combine(self.start)
        hasher.combine(self.stop)
        }
    }
