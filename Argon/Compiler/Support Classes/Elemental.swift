//
//  Elemental.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/02.
//

import Cocoa

public class Elemental
    {
    public var elementalColor:NSColor
        {
        return(.white)
        }
        
    public var browserCell:ItemBrowserCell
        {
        fatalError("This should have been overridden in a child class or should not have been called here")
        }
        
    public var isExpandable:Bool
        {
        return(false)
        }
        
    public var isList:Bool
        {
        return(false)
        }
        
    public var isSymbol:Bool
        {
        return(false)
        }
        
    public var childCount:Int
        {
        return(0)
        }
        
    public var isMethod:Bool
        {
        return(false)
        }
        
    public var isModule:Bool
        {
        return(false)
        }
        
    public var isClass:Bool
        {
        return(false)
        }
        
    public var isSlot:Bool
        {
        return(false)
        }
        
    public var title:String
        {
        return("")
        }
        
    public func accept(_ visitor:SymbolVisitor)
        {
        }
        
    public subscript(_ index:Int) -> Elemental
        {
        fatalError("This should not have been called because childCount should have returned 0")
        }
    }

public typealias Elementals = Array<Elemental>
