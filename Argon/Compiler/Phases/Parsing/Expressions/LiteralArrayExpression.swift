//
//  LiteralArrayExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralArrayExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.arrayClass)
        }
        
    let array:[Expression]
    
    init(array:[Expression])
        {
        self.array = array
        super.init()
        }
    }
