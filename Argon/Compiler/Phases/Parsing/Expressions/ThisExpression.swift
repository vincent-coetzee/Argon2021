//
//  ThisExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class ThisExpression:PsuedoVariableValuexpression
    {
    public override var displayString:String
        {
        return("this")
        }
    }
    
public class THISExpression:PsuedoVariableValuexpression
    {
    public override var displayString:String
        {
        return("This")
        }
    }
