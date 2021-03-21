//
//  OtherwiseClause.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class OtherwiseClause:SelectElementClause
    {
    init(location:SourceLocation = .zero,block:Block)
        {
        super.init(location:location)
        self.block = block
        }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.block.allocateAddresses(using:compiler)
        }
        
    override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler,subject:A3Address,exitLabel:A3Label,successLabel:A3Label) throws
        {
        try self.block.generateIntermediateCode(in: module, codeHolder: codeHolder, into: buffer, using: using)
        buffer.emitInstruction(opcode:.branch,right:.label(successLabel),comment:"JUMP TO END OF SELECT STATEMENT")
        
        }
    }
