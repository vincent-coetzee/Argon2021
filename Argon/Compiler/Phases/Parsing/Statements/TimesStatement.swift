//
//  TimesStatement.swift
//  Argon
//
//  Created by Vincent Coetzee on 16/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class TimesStatement:ControlFlowStatement
    {
    private let expression:Expression
    private let block:Block
    
    init(location:SourceLocation = .zero,expression:Expression,block:Block)
        {
        self.expression = expression
        self.block = block
        super.init(location:location)
        self.location = location
        }
    
    required init(coder: NSCoder)
        {
        self.expression = coder.decodeObject(forKey:"expression") as! Expression
        self.block = coder.decodeObject(forKey:"block") as! Block
        super.init(coder:coder)
        }
    
    
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        try self.expression.allocateAddresses(using:compiler)
        try self.block.allocateAddresses(using:compiler)
        }
    }
