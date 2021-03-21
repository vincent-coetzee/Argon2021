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
    
    init(location:SourceLocation = .zero,inductionVariable:InductionVariable,from:Expression,to:Expression,by:Expression,block:Block)
        {
        self.inductionVariable = inductionVariable
        self.block = block
        self.from = from
        self.to = to
        self.by = by
        super.init(location:location)
        block.container = self.container
        }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.block.allocateAddresses(using:compiler)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitPendingLocation(self.location)
        try self.by.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let byTemp = buffer.lastResult
        try self.from.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let fromTemp = buffer.lastResult
        buffer.emitInstruction(result:.variable(inductionVariable),left:fromTemp,opcode:.assign)
        let endLabel = A3Label.newLabel()
        try self.to.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let toTemp = buffer.lastResult
        let temp = A3Temporary.newTemporary()
        let startLabel = A3Label.newLabel()
        buffer.emitInstruction(label:startLabel,result:.temporary(temp),left:.variable(inductionVariable),opcode:.greaterthan,right:toTemp)
        buffer.emitInstruction(left:.temporary(temp),opcode:.branchIfTrue,right:.label(endLabel))
        try self.block.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitInstruction(result:.variable(inductionVariable),left:.variable(inductionVariable),opcode:.add,right:byTemp)
        buffer.emitInstruction(opcode:.branch,right:.label(startLabel))
        buffer.emitPendingLabel(label:endLabel)
        }
    }
