//
//  MethodInvocationExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class MethodInvocationExpression:InvocationExpression
    {
    let method:Method?
    let methodName:String
    let arguments:Arguments
    
    init(methodName:String,method:Method?,arguments:Arguments)
        {
        self.arguments = arguments
        self.methodName = methodName
        self.method = method
        super.init()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try arguments.allocateAddresses(using:compiler)
        try method?.allocateAddresses(using:compiler)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {

        for argument in self.arguments
            {
//            argument.generateIntermediatePushCode(into:buffer)
            buffer.emitInstruction(opcode:.parameter,right:.argument(argument))
            }
        let temp = A3Temporary.newTemporary()
        buffer.emitInstruction(result:.temporary(temp),opcode:.addressOf,right:.method(method!))
        buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),left:.temporary(temp),opcode:.invoke)
        }
    }
