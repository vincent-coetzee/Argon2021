//
//  InferredSlotExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class InferredSlotExpression:AccessExpression
    {
    let slot:String
    
    init(slot:String)
        {
        self.slot = slot
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        print("THIS NEEDS TO BE IMPLEMENTED PROPER;Y WHEN THE TYPE CHEECKING TAKS PLACES ")
        buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),opcode:.nop)
        }
    }
    
