//
//  String+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/04.
//

import Foundation

extension String
    {
    public var stringValue:String
        {
        return(self)
        }
        
    public var displayString:String
        {
        return(#""\#(self)""#)
        }
    

    public init(stringValue:String)
        {
        self.init()
        self = stringValue
        }
    }
