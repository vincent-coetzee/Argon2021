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
    
    init(location:SourceLocation = .zero,condition:Expression,block:Block)
        {
        self.condition = condition
        self.block = block
        super.init(location:location)
        }
        
    internal override func addSymbol(_ symbol: Symbol)
        {
        symbol.definingScope = self
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
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitPendingLocation(self.location)
        let label = A3Label.newLabel()
        try self.condition.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let value = buffer.lastResult
        buffer.emitInstruction(left:value,opcode:.branchIfFalse,right:.label(label))
        try self.block.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitPendingLabel(label: label)
        }
    }
