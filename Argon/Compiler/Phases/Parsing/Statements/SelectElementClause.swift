//
//  SelectElementClause.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/17.
//

import Foundation

public class SelectElementClause:Clause
    {
    public let testClauseLabel = InstructionLabel()
    public var nextClause:SelectElementClause?
    internal var block = Block()
    
    func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler,subject:ThreeAddress,exitLabel:InstructionLabel,successLabel:InstructionLabel) throws
        {
        }
    }
