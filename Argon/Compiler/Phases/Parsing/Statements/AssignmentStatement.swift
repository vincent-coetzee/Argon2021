//
//  AssignmentStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class AssignmentStatement:Statement
    {
    internal let lvalue:LValue
    internal let rvalue:Expression
    
    internal init(lvalue:LValue,rvalue:Expression)
        {
        self.lvalue = lvalue
        self.rvalue = rvalue
        super.init()
        }
    
    required init()
        {
        self.lvalue = LValue.none
        self.rvalue = Expression.none
        super.init()
        }
    }
