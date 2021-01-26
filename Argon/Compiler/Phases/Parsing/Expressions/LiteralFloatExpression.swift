//
//  LiteralFloatExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralFloatExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.floatClass)
        }
        
    let float:Argon.Float
    
    init(float:Argon.Float)
        {
        self.float = float
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),left:.float(self.float),opcode:.assign)
        }
    }
