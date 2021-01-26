//
//  ClassMakerInvocationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class ClassMakerInvocationExpression:InvocationExpression
    {
    let theClass:Class
    let arguments:Arguments
    
    init(class:Class,arguments:Arguments)
        {
        self.theClass = `class`
        self.arguments = arguments
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        for argument in self.arguments
            {
            try argument.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:using)
            let result = buffer.lastResult
            buffer.emitInstruction(opcode:.parameter,right:result)
            }
        buffer.emitInstruction(opcode:.parameter,right:.class(theClass))
        let result = A3Temporary.newTemporary()
        buffer.emitInstruction(result:.temporary(result),left:.string("class_maker"),opcode: .call)
        }
    }
