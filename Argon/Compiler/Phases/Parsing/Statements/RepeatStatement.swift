//
//  RepeatStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class RepeatStatement:ControlFlowStatement
    {
    private let condition:Expression
    private let block:Block
    
    init(location:SourceLocation = .zero,condition:Expression,block:Block)
        {
        self.condition = condition
        self.block = block
        super.init(location:location)
        }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.condition.allocateAddresses(using:compiler)
        try self.block.allocateAddresses(using:compiler)
        }
    }
