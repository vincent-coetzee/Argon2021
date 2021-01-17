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
                let temp = ThreeAddressTemporary.newTemporary()
                buffer.emitInstruction(result:temp,opcode:.addressOf,right:targetResult)
                buffer.emitInstruction(result:temp,left:temp,opcode:.add,right:result)
            case .pseudoVariable(let keyword):
                if keyword == .this
                    {
                    buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),opcode:.loadThisAddress)
                    }
                else if keyword == .This
                    {
                    buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),opcode:.loadTHISAddress)
                    }
                else if keyword == .super
                    {
                    buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),opcode:.loadSuperAddress)
                    }
            case .variable(let variable):
                buffer.emitInstruction(result:ThreeAddressTemporary.newTemporary(),opcode:.addressOf,right:variable)
            case .arrayAccess(let lvalue,let expression):
                try lvalue.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                let address = buffer.lastResult
                try expression.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                let index = buffer.lastResult
                let eight = ThreeAddressTemporary.newTemporary()
                buffer.emitInstruction(result:eight,opcode:.assign,right:8)
                buffer.emitInstruction(result:index,left:index,opcode:.mul,right:eight)
                buffer.emitInstruction(result:address,left:address,opcode:.add,right:index)
            }
        }
    }
