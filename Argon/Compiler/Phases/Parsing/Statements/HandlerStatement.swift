//
//  HandlerStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class HandlerStatement:Statement
    {
    internal let inductionVariable:InductionVariable
    internal let block:Block
        
    init(location:SourceLocation = .zero,inductionVariable:InductionVariable,block:Block)
        {
        self.inductionVariable = inductionVariable
        self.block = block
        super.init(location:location)
        }
        
    func asHandlerSymbol() -> HandlerSymbol
        {
        return(HandlerSymbol(shortName:"_HANDLER_\(Argon.nextIndex())",inductionVariable: self.inductionVariable,block:self.block))
        }
        
    internal override func generateIntermediateCode(in module:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        }
    }
