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
    public var isClassSlot:Bool
        {
        return(self.attributes.contains(.class))
        }
        
    public var isMetaSlot:Bool
        {
        return(self.attributes.contains(.meta))
        }
        
    public var container:Symbol?
    internal let attributes:SlotAttributes
    internal var virtualReadBlock:VirtualSlotBlock?
    internal var virtualWriteBlock:VirtualSlotBlock?
    
    internal init(name:Name,class:Class,container:Symbol? = nil,attributes:SlotAttributes)
        {
        self.container = container
        self.attributes = attributes
        super.init(shortName: name.first,class: `class`)
        self._class = `class`
        }
        
    internal init(shortName:Identifier,class:Class,container:Symbol? = nil,attributes:SlotAttributes)
        {
        self.container = container
        self.attributes = attributes
        super.init(shortName: shortName,class: .voidClass)
        self._class = `class`
        }
        
    internal required init()
        {
        self.container = nil
        self.attributes = []
        super.init(shortName: "Nil",class: Argon.rootModule.nilClass)
        self._class = Argon.rootModule.nilClass
        }
        
    internal func slotType(_ slotNames:[String]) -> Type
        {
        if slotNames.count == 0
            {
            return(self.type)
            }
        return(self.type.slotType(slotNames))
        }
        
    internal func fieldHash(n:Int) -> Int
        {
        return(self.shortName.hashValue % n)
        }
    }

typealias Slots = Array<Slot>
