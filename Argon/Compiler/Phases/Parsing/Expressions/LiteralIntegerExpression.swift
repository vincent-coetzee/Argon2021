//
//  LiteralIntegerExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralIntegerExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.integerClass)
        }
        
    let integer:Argon.Integer
    
    init()
        {
        self.integer = 0
        super.init()
        }
        
    init(integer:Argon.Integer)
        {
        self.integer = integer
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),left:.integer(self.integer),opcode:.assign)
        }
        
    internal override func generateIntermediatePushCode(into buffer:A3CodeBuffer)
        {
        buffer.emitInstruction(opcode:.parameter,right:.integer(self.integer))
        }
    }
