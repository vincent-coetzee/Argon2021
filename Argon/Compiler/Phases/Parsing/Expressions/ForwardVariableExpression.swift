//
//  ForwardVariableExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class ForwardVariableExpression:AccessExpression
    {
    let variable:Variable
    
    init(variable:Variable)
        {
        self.variable = variable
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        let temp = A3Temporary.newTemporary()
        buffer.emitInstruction(result:.temporary(temp),left:.variable(variable),opcode:.assign)
        }
    }
    
