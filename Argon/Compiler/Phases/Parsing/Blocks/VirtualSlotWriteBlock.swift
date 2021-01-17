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
    internal init(location:SourceLocation = .zero,block:Block)
        {
        super.init(location:location)
        self.statements = block.statements
        self.symbols = block.symbols
        }
        
    override init(location:SourceLocation = .zero)
        {
        super.init(location:location)
        }
    }
