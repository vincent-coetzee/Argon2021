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
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.expression.allocateAddresses(using:compiler)
        try self.block.allocateAddresses(using:compiler)
        }
        
    override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler,subject:A3Address,exitLabel:A3Label,successLabel:A3Label) throws
        {
        let testResult = A3Temporary.newTemporary()
        let expressionResult = A3Temporary.newTemporary()
        let entryPoint = A3Label.newLabel()
        try self.expression.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitInstruction(result:.temporary(testResult),left:subject,opcode:.equals,right:.temporary(expressionResult),comment:"CHECK IF SUBJECT MATCHES THE CONDiTION")
        buffer.emitInstruction(left:.temporary(testResult),opcode:.branchIfTrue,right:.label(entryPoint),comment:"JUMP TO THIS CLAUSE'S CODE TO EXECUTE IT")
        let target = self.nextClause == nil ? exitLabel : self.nextClause!.testClauseLabel
        buffer.emitInstruction(opcode:.branch,right:.label(target),comment:"EXIT THE CLAUSE BECAUSE CONDITION WAS NOT SATISFIED OR NO OTHERWISE CLAUSE")
        buffer.emitPendingLabel(label: entryPoint)
        try self.block.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitInstruction(opcode:.branch,right:.label(successLabel),comment:"EXIT BECAUSE REACHED END OF WHEN BLOCK")
        try self.nextClause?.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using, subject: subject, exitLabel: exitLabel, successLabel: successLabel)
        }
    }

typealias WhenClauses = Array<WhenClause>
