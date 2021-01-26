//
//  SlotExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class SlotExpression:AccessExpression
    {
    let target:Expression
    let slot:Expression
    
    init(target:Expression,slot:Expression)
        {
        self.target = target
        self.slot = slot
        super.init()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try target.allocateAddresses(using:compiler)
        try slot.allocateAddresses(using:compiler)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        buffer.emitComment("This code needs to be cleaned up")
        try self.target.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let targetAddress = buffer.lastResult
        try self.slot.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let slotAddress = buffer.lastResult
        buffer.emitInstruction(result: .temporary(A3Temporary.newTemporary()), left: slotAddress, opcode: .slot, right: targetAddress)
        }
    }
    
