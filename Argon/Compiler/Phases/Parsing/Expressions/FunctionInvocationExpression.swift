//
//  FunctionInvocationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class FunctionInvocationExpression:InvocationExpression
    {
    let function:Function
    let arguments:Arguments
    
    init(function:Function,arguments:Arguments)
        {
        self.function = function
        self.arguments = arguments
        super.init()
        }
    }
