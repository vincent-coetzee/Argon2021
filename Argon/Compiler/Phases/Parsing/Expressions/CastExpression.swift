//
//  CastExpression.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/26.
//

import Foundation

public class CastExpression:Expression
    {
    let rhs:Expression
    let lhs:Expression
    
    init(lhs:Expression,rhs:Expression)
        {
        self.lhs = lhs
        self.rhs = rhs
        super.init()
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.lhs.allocateAddresses(using:compiler)
        try self.rhs.allocateAddresses(using:compiler)
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        try self.lhs.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let lhsResult = buffer.lastResult
        try self.rhs.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let rhsResult = buffer.lastResult
        buffer.emitInstruction(opcode: .parameter, right: lhsResult)
        buffer.emitInstruction(opcode: .parameter, right: rhsResult)
        buffer.emitInstruction(result:A3Temporary.makeNew(),opcode: .syscall,right: .string("sys_cast"))
        }
    }
