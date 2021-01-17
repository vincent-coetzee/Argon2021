//
//  SemanticVersionNumber.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/15.
//

import Foundation

public struct SemanticVersionNumber:Equatable,Comparable,Hashable
    {
    public static func < (lhs: SemanticVersionNumber, rhs: SemanticVersionNumber) -> Bool
        {
        return(lhs.major < rhs.major && lhs.minor < rhs.minor && lhs.patch < rhs.patch)
        }
    
    public static let one = SemanticVersionNumber(major:1)
    
    let major:Int
    let minor:Int
    let patch:Int
    
    init(major:Int,minor:Int = 0,patch:Int = 0)
        {
        self.major = major
        self.minor = minor
        self.patch = patch
        }
    }
