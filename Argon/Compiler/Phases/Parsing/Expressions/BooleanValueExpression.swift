//
//  BooleanValueExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

    
public class BooleanValueExpression:ScalarExpression
    {
    let booleanValue:Bool
    
    init(boolean:Bool)
        {
        self.booleanValue = boolean
        super.init()
        }
    }
