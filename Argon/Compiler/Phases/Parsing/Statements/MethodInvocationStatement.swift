//
//  MethodInvocationStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class MethodInvocationStatement:ControlFlowStatement
    {
    }

internal class InvocationStatement:MethodInvocationStatement
    {
    let name:Name
    let arguments:Arguments
    
    init(location:SourceLocation = .zero,name:Name,arguments:Arguments)
        {
        self.name = name
        self.arguments = arguments
        super.init(location:location)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitPendingLocation(self.location)
        let temp = A3Temporary.newTemporary()
        buffer.emitInstruction(result:.temporary(temp),opcode:.addressOf,right:.name(name))
        for argument in self.arguments
            {
            buffer.emitInstruction(opcode:.parameter,right:.argument(argument))
            }
        buffer.emitInstruction(opcode:.invokeAddress,right:.temporary(temp))
        }
    }
