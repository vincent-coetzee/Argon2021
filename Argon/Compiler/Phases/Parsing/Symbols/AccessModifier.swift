//
//  AccessModifier.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/27.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public enum AccessModifier:String
    {
    case none = "none"
    case `public` = "public"
    case `private` = "private"
    case protected = "protected"
    case export = "export"
    
    public init(_ keyword:Token.Keyword)
        {
        self.init(rawValue:keyword.rawValue)!
        }
    }
