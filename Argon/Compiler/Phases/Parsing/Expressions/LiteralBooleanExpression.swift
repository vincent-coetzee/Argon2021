//
//  LiteralBooleanExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

    
public class LiteralBooleanExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.booleanClass)
        }
        
    let boolean:Bool
    
    init(boolean:Bool)
        {
        self.boolean = boolean
        super.init()
        }
    }
