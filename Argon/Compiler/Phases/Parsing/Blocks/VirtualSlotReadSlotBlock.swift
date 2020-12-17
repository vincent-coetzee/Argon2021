//
//  VirtualSlotReadSlotBlock.swift
//  Argon
//
//  Created by Vincent Coetzee on 22/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class VirtualSlotReadSlotBlock:VirtualSlotReadBlock
    {
    private let slotOffset:Expression
    
    internal init(_ slotOffset:Expression)
        {
        self.slotOffset = slotOffset
        super.init()
        }
    
    required init()
        {
        fatalError("init() has not been implemented")
        }
    }
