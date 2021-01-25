//
//  Int+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/16.
//

import Foundation

extension Int:ThreeAddress
    {
    public func write(file: ObjectFile) throws
        {
        try file.write(character:"I")
        try file.write(self)
        }
        
    public var displayString:String
        {
        return(String(self))
        }
    }
