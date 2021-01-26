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
        
    internal func allocateAddresses(using compiler:Compiler) throws
        {
        switch(self)
            {
            case .variable(let variable):
                try variable.allocateAddresses(using:compiler)
            case .arrayAccess(let left,let expression):
                try left.allocateAddresses(using:compiler)
                try expression.allocateAddresses(using:compiler)
            case .slotAccess(let left,let expression):
                try left.allocateAddresses(using:compiler)
                try expression.allocateAddresses(using:compiler)
            default:
                break
            }
        }
        
    internal func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        switch(self)
            {
            case .slotAccess(let target,let slots):
                try slots.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                let result = buffer.lastResult
                try target.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                let targetResult = buffer.lastResult
                let temp = A3Temporary.newTemporary()
                buffer.emitInstruction(result:.temporary(temp),opcode:.addressOf,right:targetResult)
                buffer.emitInstruction(result:.temporary(temp),left:.temporary(temp),opcode:.add,right:result)
            case .pseudoVariable(let keyword):
                if keyword == .this
                    {
                    buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),opcode:.loadThisAddress)
                    }
                else if keyword == .This
                    {
                    buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),opcode:.loadTHISAddress)
                    }
                else if keyword == .super
                    {
                    buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),opcode:.loadSuperAddress)
                    }
            case .variable(let variable):
                buffer.emitInstruction(result:.temporary(A3Temporary.newTemporary()),opcode:.addressOf,right:.variable(variable))
            case .arrayAccess(let lvalue,let expression):
                try lvalue.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                let address = buffer.lastResult
                try expression.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
                let index = buffer.lastResult
                let eight = A3Temporary.newTemporary()
                buffer.emitInstruction(result:.temporary(eight),opcode:.assign,right:.integer(8))
                buffer.emitInstruction(result:index,left:index,opcode:.mul,right:.temporary(eight))
                buffer.emitInstruction(result:address,left:address,opcode:.add,right:index)
            }
        }
    }
