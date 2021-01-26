//
//  LiteralStringExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class LiteralStringExpression:LiteralExpression
    {
    public override var typeClass:Class
        {
        return(Class.stringClass)
        }
        
    let string:String
    
    init(string:String)
        {
        self.string = string
        super.init()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        fatalError("Logic should have been added here")
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),left:.string(self.string),opcode:.assign)
        }
    }
    
