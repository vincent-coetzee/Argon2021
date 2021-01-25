//
//  String+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/04.
//

import Foundation

extension String:ThreeAddress
    {
    public var displayString:String
        {
        return(#""\#(self)""#)
        }
    
    public func write(file: ObjectFile) throws
        {
        try file.write(character:"S")
        try file.write(self)
        }
    }
