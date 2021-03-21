//
//  Slot.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Cocoa

public class Slot:Variable,NSCoding
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
        
    public var isLastSlot:Bool = false
        
    public var cloned:Slot
        {
        return(Self(shortName:self.shortName,class:self._class,container:self.container,attributes:self.attributes))
        }
        
    public func cloned(withInitialValue:Expression?) -> Slot
        {
        let slot = self.cloned
        slot.initialValue = withInitialValue
        return(slot)
        }
        
    public var isRawSlot:Bool
        {
        return(false)
        }
        
    public var isRegularSlot:Bool
        {
        return(self.attributes.contains(.regular))
        }
        
    public var isClassSlot:Bool
        {
        return(self.attributes.contains(.class))
        }
        
    public var isVirtualSlot:Bool
        {
        return(false)
        }
        
    public var isAliasSlot:Bool
        {
        return(false)
        }
        
    public override var icon:NSImage
        {
        return(NSImage(named:"IconSlot64")!)
        }
        
    public var slotName:String
        {
        return(self.container.shortName + "\\" + self.shortName)
        }
        
    public var slotOffset:Int = 0
    internal let attributes:SlotAttributes
    internal var virtualReadBlock:VirtualSlotBlock?
    internal var virtualWriteBlock:VirtualSlotBlock?
    
    internal init(name:Name,class:Class,container:SymbolContainer = .nothing,attributes:SlotAttributes)
        {
        self.attributes = attributes
        super.init(shortName: name.first,class: `class`)
        self.container = container
        self._class = `class`
        }
        
    internal required init(shortName:String,class:Class,container:SymbolContainer = .nothing,attributes:SlotAttributes)
        {
        self.attributes = attributes
        super.init(shortName: shortName,class: .voidClass)
        self.container = container
        self._class = `class`
        }
        
    internal required init()
        {
        self.attributes = []
        super.init(shortName: "Nil",class: Class.nilClass)
        self.container = container
        self._class = Class.nilClass
        }
        
    public override func encode(with coder: NSCoder)
        {
        super.encode(with:coder)
        coder.encode(self.slotOffset,forKey:"slotOffset")
        coder.encode(self.attributes.rawValue,forKey:"attributes")
        }
    
    public required init?(coder: NSCoder)
        {
        self.attributes = SlotAttributes(rawValue:Int(coder.decodeInt64(forKey:"slotAttributes")))
        super.init(coder:coder)
        self.slotOffset = Int(coder.decodeInt64(forKey:"slotOffset"))
        }
        
    internal func fieldHash(n:Int) -> Int
        {
        return(self.shortName.hashValue % n)
        }
    }

typealias Slots = Array<Slot>

typealias SlotDictionary = Dictionary<String,Slot>
