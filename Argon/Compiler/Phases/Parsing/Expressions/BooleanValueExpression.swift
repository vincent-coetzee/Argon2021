//
//  BooleanValueExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

    
public class BooleanValueExpression:ScalarExpression
    {
    let booleanValue:Bool
    
    init(boolean:Bool)
        {
        self.booleanValue = boolean
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),left:.boolean(self.booleanValue ? .trueValue : .falseValue),opcode:.assign)
        }

    }
