//
//  AssignmentStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class AssignmentStatement:Statement
    {
    internal let lvalue:LHSValue
    internal let rvalue:Expression
    
    internal init(location:SourceLocation = .zero,lvalue:LHSValue,rvalue:Expression)
        {
        self.lvalue = lvalue
        self.rvalue = rvalue
        super.init(location:location)
        }
        
    public override func typeCheck() throws
        {
//        let lhsType = self.lvalue.type
//        let rhsType = self.rvalue.type
//        if !rhsType.isSubtype(of: lhsType)
//            {
//            throw(CompilerError(.typeMismatch(lhsType,rhsType),self.location))
//            }
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        buffer.emitPendingLocation(self.location)
        try self.rvalue.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        let value = buffer.lastResult
        try self.lvalue.generateIntermediateCode(in:module,codeHolder:codeHolder,into:buffer,using:using)
        let address = buffer.lastResult
        buffer.emitInstruction(left:address,opcode:.setWordAtAddress,right:value)
        }
    }
