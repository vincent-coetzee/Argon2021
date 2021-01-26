//
//  LiteralEnumerationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralEnumerationExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(EnumerationClass(shortName: self.name, baseClass: baseClass))
        }
        
    let name:String
    let baseClass:Class
    
    init(enumeration:Enumeration)
        {
        self.name = enumeration.shortName
        self.baseClass = enumeration.baseClass
        super.init()
        }
    }
