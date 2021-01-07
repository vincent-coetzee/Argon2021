//
//  LetStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 12/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class LetStatement:Statement
    {
    private let variable:Variable
    
    init(variable:Variable)
        {
        self.variable = variable
        super.init()
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        if let expression = variable.initialValue
            {
            try expression.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
            let result = buffer.lastResult
            buffer.emitInstruction(ThreeAddressInstruction(result:variable,left:result,opcode:.copy))
            }
        }
    }
