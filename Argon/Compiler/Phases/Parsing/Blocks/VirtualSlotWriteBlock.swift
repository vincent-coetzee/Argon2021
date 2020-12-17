//
//  VirtualSlotWriteBlock.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class VirtualSlotWriteBlock:VirtualSlotBlock
    {
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
