//
//  VirtualSlotBlock.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class VirtualSlotBlock:Block,Codable
    {
    public required init(from decoder:Decoder) throws
        {
        super.init()
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
