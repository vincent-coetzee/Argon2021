//
//  IdentifierExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class IdentifierExpression:Expression
    {
    let identifier:String
    
    init(identifier:String)
        {
        self.identifier = identifier
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),opcode:.addressOf,right:.string(self.identifier))
        }
    }
