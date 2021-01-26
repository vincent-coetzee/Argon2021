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
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override init(block:Block)
        {
        super.init(block:block)
        }
        
    override init()
        {
        super.init()
        }
        
    }
