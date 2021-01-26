//
//  VirtualSlotWriteSlotBlock.swift
//  Argon
//
//  Created by Vincent Coetzee on 22/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation


internal class VirtualSlotWriteSlotBlock:VirtualSlotWriteBlock
    {
    private let slotOffset:Expression
    
    internal init(_ slotOffset:Expression)
        {
        self.slotOffset = slotOffset
        super.init()
        }
        

    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
