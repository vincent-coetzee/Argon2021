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
    
    init(location:SourceLocation = .zero,condition:Expression,block:Block)
        {
        self.condition = condition
        self.block = block
        super.init(location:location)
        }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.condition.allocateAddresses(using:compiler)
        try self.block.allocateAddresses(using:compiler)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitPendingLocation(self.location)
        let entryLabel = A3Label()
        buffer.emitPendingLabel(label: entryLabel)
        try self.condition.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let result = buffer.lastResult
        let label = A3Label()
        buffer.emitInstruction(left:result,opcode:.branchIfFalse,right:.label(label))
        try self.block.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitInstruction(opcode:.branch,right:.label(entryLabel))
        buffer.emitPendingLabel(label:label)
        }
    }
