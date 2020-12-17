//
//  TimesStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class TimesStatement:ControlFlowStatement
    {
    private let expression:Expression
    private let block:Block
    
    init(expression:Expression,block:Block,location:SourceLocation = .zero)
        {
        self.expression = expression
        self.block = block
        super.init()
        self.location = location
        }
    
    required init()
        {
        self.expression = Expression.none
        self.block = Block()
        super.init()
        }
    }
