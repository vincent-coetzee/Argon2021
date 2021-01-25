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
        
    init(shortName:String,inductionVariable:InductionVariable,block:Block)
        {
        self.inductionVariable = inductionVariable
        self.block = block
        super.init(shortName:shortName)
        }
        
    required init(file:ObjectFile) throws
        {
        self.inductionVariable = try file.readObject() as! InductionVariable
        self.block = Block()
        try super.init(file:file)
        }
    }
