//
//  VirtualSlotReadBlock.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class VirtualSlotReadBlock:VirtualSlotBlock
    {
    internal init(statements:[Statement])
        {
        super.init()
        self.setStatements(statements)
        }
    
    internal init(block:Block)
        {
        super.init()
        self.statements = block.statements
        self.symbols = block.symbols
        }
        
    required init()
        {
        fatalError("init() has not been implemented")
        }
    }
