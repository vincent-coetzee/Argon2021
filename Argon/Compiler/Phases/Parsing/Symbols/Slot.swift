//
//  Slot.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Slot:Variable
    {
    public var container:Symbol?
    internal let attributes:SlotAttributes
    internal var virtualReadBlock = VirtualSlotBlock()
    internal var virtualWriteBlock = VirtualSlotBlock()
        
    internal init(name:Name,type:Type,container:Symbol? = nil,attributes:SlotAttributes)
        {
        self.container = container
        self.attributes = attributes
        super.init(shortName: name.first,type: type)
        self._type = type
        }
        
    internal init(shortName:Identifier,type:Type,container:Symbol? = nil,attributes:SlotAttributes)
        {
        self.container = container
        self.attributes = attributes
        super.init(shortName: shortName,type: type)
        self._type = type
        }
        
    internal required init()
        {
        self.container = nil
        self.attributes = []
        super.init(shortName: "Nil",type: Argon.rootModule.nilInstance.type)
        self._type = Argon.rootModule.nilInstance.type
        }
    
    internal required init(_ parser: Parser)
        {
        fatalError("init(_:) has not been implemented")
        }
        
    internal func slotType(_ slotNames:[String]) -> Type
        {
        if slotNames.count == 0
            {
            return(self.type)
            }
        return(self.type.slotType(slotNames))
        }
    }

typealias Slots = Array<Slot>
