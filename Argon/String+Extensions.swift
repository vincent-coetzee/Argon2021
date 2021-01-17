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
    }
