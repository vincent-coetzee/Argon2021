//
//  LHSValue.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/23.
//

import Foundation

public indirect enum LHSValue
    {
    case variable(Variable)
    case pseudoVariable(Token.Keyword)
    case arrayAccess(LHSValue,Expression)
    case slotAccess(LHSValue,Expression)
        
    internal func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        switch(self)
            {
            case .slotAccess(let target,let slots):
                try slots.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                let result = buffer.lastResult
                try target.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                let targetResult = buffer.lastResult
                buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),left:targetResult,opcode:.slot,right:result)
            case .pseudoVariable(let keyword):
                if keyword == .this
                    {
                    buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),left:ThisExpression(),opcode:.copy)
                    }
                else if keyword == .This
                    {
                    buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),left:THISExpression(),opcode:.copy)
                    }
                else if keyword == .super
                    {
                    buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),left:SuperExpression(),opcode:.copy)
                    }
            case .variable(let variable):
                buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),left:variable,opcode:.copy)
            case .arrayAccess(let lvalue,let expression):
                try expression.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                let index = buffer.lastResult
                let temp = ThreeAddressTemporary.newTemporary()
                buffer.emitInstruction(result:temp,left:index,opcode:.mul,right:8)
                let offset = buffer.lastResult
                try lvalue.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                buffer.emitInstruction(result:offset,left:temp,opcode:.address,right:index)
                buffer.emitInstruction(result:offset,left:offset,opcode:.assign,right:"")
            }
        }
    }
