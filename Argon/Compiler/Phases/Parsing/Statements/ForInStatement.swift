//
//  ForInStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ForInStatement:ControlFlowStatement
    {
    private let block:Block
    private let inductionVariable:InductionVariable
    private let from:Expression
    private let to:Expression
    private let by:Expression
    
    init(inductionVariable:InductionVariable,from:Expression,to:Expression,by:Expression,block:Block,location:SourceLocation = .zero)
        {
        self.inductionVariable = inductionVariable
        self.block = block
        self.from = from
        self.to = to
        self.by = by
        super.init()
        self.location = location
        }
    
    required init()
        {
        self.block = Block()
        self.inductionVariable = InductionVariable(shortName:"Error",type:.void)
        self.from = Expression.none
        self.to = Expression.none
        self.by = Expression.none
        super.init()
        }
    }
