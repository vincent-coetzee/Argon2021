//
//  HandlerSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/25.
//

import Foundation

public class HandlerSymbol:Symbol
    {
    internal let inductionVariable:InductionVariable
    internal let block:Block
    internal var codeBuffer = A3CodeBuffer()
        
    init(shortName:String,inductionVariable:InductionVariable,block:Block)
        {
        self.inductionVariable = inductionVariable
        self.block = block
        super.init(shortName:shortName)
        }
        
    public required init?(coder:NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    }
