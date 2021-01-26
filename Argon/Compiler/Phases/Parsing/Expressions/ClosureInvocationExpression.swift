//
//  ClosureInvocationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class ClosureInvocationExpression:InvocationExpression
    {
    let closure:Expression
    let arguments:Arguments
    
    init(closure:Expression,arguments:Arguments)
        {
        self.closure = closure
        self.arguments = arguments
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        for argument in self.arguments
            {
//            buffer.emitInstruction(opcode:.push,right:argument)
            buffer.emitInstruction(opcode:.parameter,right:.argument(argument))
            }
        try self.closure.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let closureResult = buffer.lastResult
        buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),left:closureResult,opcode:.invoke)
        }
    }
