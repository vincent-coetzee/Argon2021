//
//  WhileStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 12/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class WhileStatement:ControlFlowStatement
    {
    private let condition:Expression
    private let block:Block
    
    init(condition:Expression,block:Block,location:SourceLocation = .zero)
        {
        self.condition = condition
        self.block = block
        super.init()
        self.location = location
        }
    }
