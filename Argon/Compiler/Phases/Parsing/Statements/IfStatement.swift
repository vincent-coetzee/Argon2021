//
//  IfStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class IfStatement:ControlFlowStatement
    {
    private let condition:Expression
    private let block:Block
    internal var elseClauses = ElseClauses()
    
    required init()
        {
        self.condition = Expression.none
        self.block = Block()
        super.init()
        }
    
    init(condition:Expression,block:Block)
        {
        self.condition = condition
        self.block = block
        super.init()
        }
        
    internal override func addSymbol(_ symbol: Symbol)
        {
        self.block.addSymbol(symbol)
        }
    
    internal override func addStatement(_ statement: Statement)
        {
        self.block.addStatement(statement)
        }
    
    internal override func lookup(shortName: String) -> SymbolSet?
        {
        return(self.block.lookup(shortName:shortName))
        }
    }
