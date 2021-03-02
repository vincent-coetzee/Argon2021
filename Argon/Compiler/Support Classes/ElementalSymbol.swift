//
//  ElementalSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/02.
//

import Cocoa

public class ElementalSymbol:Elemental
    {
    public override var elementalColor:NSColor
        {
        if self.symbol is Module
            {
            return(NSColor.argonLime)
            }
        else if self.symbol is Class
            {
            return(NSColor.argonNeonPink)
            }
        else if self.symbol is Slot
            {
            return(NSColor.argonNeonOrange)
            }
        else if self.symbol is Method || self.symbol is MethodInstance
            {
            return(NSColor.argonSeaGreen)
            }
        else if symbol is Enumeration
            {
            return(NSColor.argonNeonYellow)
            }
        else if symbol is Slot
            {
            return(NSColor.argonNeonPink)
            }
        else
            {
            return(NSColor.white)
            }
        }
        
    public override var browserCell:ItemBrowserCell
        {
        return(self.symbol.browserCell)
        }
        
    public override var isExpandable:Bool
        {
        return(self.isModule || self.isMethod || (self.isClass && self.childCount > 0))
        }
        
    public override var isSymbol:Bool
        {
        return(true)
        }
        
    public override var childCount:Int
        {
        return(self.symbol.elementals.count)
        }
        
    public override var isSlot:Bool
        {
        return(self.symbol is Slot)
        }
        
    public override var isModule:Bool
        {
        return(self.symbol is Module)
        }
        
    public override var isMethod:Bool
        {
        return(self.symbol is Method)
        }
        
    public override var isClass:Bool
        {
        return(self.symbol is Class)
        }
        
    public override var title:String
        {
        return(self.symbol.shortName)
        }
        
    private let symbol:Symbol
    
    init(symbol:Symbol)
        {
        self.symbol = symbol
        super.init()
        }
        
    public override func accept(_ visitor:SymbolVisitor)
        {
        self.symbol.accept(visitor)
        }
        
    public override subscript(_ index:Int) -> Elemental
        {
        return(self.symbol.elementals[index])
        }
    }
