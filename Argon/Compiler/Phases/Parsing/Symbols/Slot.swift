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
    public var slotNameHornerHashValue:Int
        {
        var hashValue:UInt = 0
        for character in self.slotName
            {
            let value = character.unicodeScalars.reduce(into:0) {t,c in t += c.value}
            hashValue = (hashValue << 4) + UInt(value)
            let intermediate = hashValue & 0xF0000000
            if intermediate != 0
                {
                hashValue ^= intermediate >> 24
                }
            hashValue &= ~intermediate
            }
        return(Int(hashValue))
        }
        
    public var isRegularSlot:Bool
        {
        return(self.attributes.contains(.regular))
        }
        
    public var isClassSlot:Bool
        {
        return(self.attributes.contains(.class))
        }
        
    public var slotName:String
        {
        return(self.containingSymbol!.shortName + "\\" + self.shortName)
        }
        
    public var slotOffset:Int = 0
    public var containingSymbol:Symbol?
    internal let attributes:SlotAttributes
    internal var virtualReadBlock:VirtualSlotBlock?
    internal var virtualWriteBlock:VirtualSlotBlock?
    
    internal init(name:Name,class:Class,container:Symbol? = nil,attributes:SlotAttributes)
        {
        self.containingSymbol = container
        self.attributes = attributes
        super.init(shortName: name.first,class: `class`)
        self._class = `class`
        }
        
    internal init(shortName:Identifier,class:Class,container:Symbol? = nil,attributes:SlotAttributes)
        {
        self.containingSymbol = container
        self.attributes = attributes
        super.init(shortName: shortName,class: .voidClass)
        self._class = `class`
        }
        
    internal required init()
        {
        self.containingSymbol = nil
        self.attributes = []
        super.init(shortName: "Nil",class: Class.nilClass)
        self._class = Class.nilClass
        }
        
    enum CodingKeys:String,CodingKey
        {
        case slotOffset
        case attributes
        case readBlock
        case writeBlock
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.slotOffset = try values.decode(Int.self,forKey:.slotOffset)
        self.attributes = try values.decode(SlotAttributes.self,forKey:.attributes)
        self.virtualReadBlock = try values.decode(VirtualSlotBlock?.self,forKey:.readBlock)
        self.virtualWriteBlock = try values.decode(VirtualSlotBlock?.self,forKey:.writeBlock)
        try super.init(from: values.superDecoder())
        }
        
    public override func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.slotOffset,forKey:.slotOffset)
        try container.encode(self.attributes,forKey:.attributes)
        try container.encode(self.virtualReadBlock,forKey:.readBlock)
        try container.encode(self.virtualWriteBlock,forKey:.writeBlock)
        try super.encode(to: container.superEncoder())
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
