//
//  WhenClause.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class WhenClause:SelectElementClause
    {
    private let expression:Expression

    init(location:SourceLocation = .zero,expression:Expression,block:Block)
        {
        self.expression = expression
        super.init(location:location)
        self.block = block
        }
        
    override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler,subject:ThreeAddress,exitLabel:InstructionLabel,successLabel:InstructionLabel) throws
        {
        let testResult = ThreeAddressTemporary.newTemporary()
        let expressionResult = ThreeAddressTemporary.newTemporary()
        let entryPoint = InstructionLabel.newLabel()
        try self.expression.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitInstruction(result:testResult,left:subject,opcode:.equals,right:expressionResult,comment:"CHECK IF SUBJECT MATCHES THE CONDiTION")
        buffer.emitInstruction(left:testResult,opcode:.branchIfTrue,right:entryPoint,comment:"JUMP TO THIS CLAUSE'S CODE TO EXECUTE IT")
        let target = self.nextClause == nil ? exitLabel : self.nextClause!.testClauseLabel
        buffer.emitInstruction(opcode:.branch,right:target,comment:"EXIT THE CLAUSE BECAUSE CONDITION WAS NOT SATISFIED OR NO OTHERWISE CLAUSE")
        buffer.emitPendingLabel(label: entryPoint)
        try self.block.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitInstruction(opcode:.branch,right:successLabel,comment:"EXIT BECAUSE REACHED END OF WHEN BLOCK")
        try self.nextClause?.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using, subject: subject, exitLabel: exitLabel, successLabel: successLabel)
        }
    }

typealias WhenClauses = Array<WhenClause>
