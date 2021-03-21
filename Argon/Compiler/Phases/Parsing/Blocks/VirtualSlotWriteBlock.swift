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
    public required init(from decoder:Decoder) throws
        {
        try super.init(from:decoder)
        }
        
    override init(block:Block)
        {
        super.init(block:block)
        }
        
    override init()
        {
        super.init()
        }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    internal init(location:SourceLocation = .zero,block:Block)
//        {
//        super.init(location:location)
//        self.statements = block.statements
//        self.symbols = block.symbols
//        }
//        
//    override init(location:SourceLocation = .zero)
//        {
//        super.init(location:location)
//        }
    }
