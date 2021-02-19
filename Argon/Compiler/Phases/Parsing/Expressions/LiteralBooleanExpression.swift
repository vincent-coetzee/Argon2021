//
//  LiteralBooleanExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

    
public class LiteralBooleanExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.booleanClass)
        }
        
    let boolean:Bool
    
    init(boolean:Bool)
        {
        self.boolean = boolean
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),left:.boolean(self.boolean ? .trueValue : .falseValue),opcode:.assign)
        }
    }
