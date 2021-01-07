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
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        try self.by.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let byTemp = buffer.lastResult
        try self.from.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let fromTemp = buffer.lastResult
        buffer.emitInstruction(result:inductionVariable,left:fromTemp,opcode:.copy)
        let endLabel = InstructionLabel.newLabel()
        try self.to.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let toTemp = buffer.lastResult
        let temp = ThreeAddressTemporary.newTemporary()
        let startLabel = InstructionLabel.newLabel()
        buffer.emitInstruction(label:startLabel,result:temp,left:inductionVariable,opcode:.greater,right:toTemp)
        buffer.emitInstruction(left:temp,opcode:.branchIfTrue,right:endLabel)
        try self.block.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitInstruction(result:inductionVariable,left:inductionVariable,opcode:.add,right:byTemp)
        buffer.emitInstruction(left:startLabel,opcode:.branch)
        buffer.emitPendingLabel(label:endLabel)
        }
    }
