//
//  ForkStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ForkStatement:ControlFlowStatement
    {
    internal let expression:Expression
    
    init(expression:Expression,location:SourceLocation = .zero)
        {
        self.expression = expression
        super.init()
        self.location = location
        }
    
    required init()
        {
        self.expression = Expression.none
        super.init()
        }
    }
