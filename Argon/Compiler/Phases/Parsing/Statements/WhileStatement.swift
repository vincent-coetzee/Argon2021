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
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        buffer.emitPendingLocation(self.location)
        let entryLabel = InstructionLabel()
        buffer.emitPendingLabel(label: entryLabel)
        try self.condition.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let result = buffer.lastResult
        let label = InstructionLabel()
        buffer.emitInstruction(left:result,opcode:.branchIfFalse,right:label)
        try self.block.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitInstruction(opcode:.branch,right:entryLabel)
        buffer.emitPendingLabel(label:label)
        }
    }
