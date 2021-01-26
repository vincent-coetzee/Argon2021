//
//  MakerInvocationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class MakerInvocationExpression:InvocationExpression
    {
    let theClass:Class
    let arguments:Arguments
    
    init(class:Class,arguments:Arguments)
        {
        self.theClass = `class`
        self.arguments = arguments
        super.init()
        }
    }
