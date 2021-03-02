//
//  SymbolList.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/02.
//

import Cocoa

public class ElementalList:Elemental,Collection
    {
    public override var browserCell:ItemBrowserCell
        {
        return(ItemListBrowserCell(list:self,textColor:NSColor.argonNeonPink))
        }
        
    public override var isList:Bool
        {
        return(true)
        }
        
    public override var title:String
        {
        return(self.name)
        }
        
    public var startIndex: Int
        {
        return(self.list.startIndex)
        }
        
    public var endIndex: Int
        {
        return(self.list.endIndex)
        }
    
    public var count:Int
        {
        return(self.list.count)
        }
        
    public var titles:[String]
        {
        return(self.list.map{$0.title})
        }
        
    private let list:Elementals
    private let name:String
    
    init(name:String,list:Elementals)
        {
        self.list = list
        self.name = name
        super.init()
        }
        
    public func index(after:Int) -> Int
        {
        return(self.list.index(after:after))
        }
        
    public override subscript(_ index:Int) -> Elemental
        {
        return(self.list[index])
        }
        
    public func rowHeight(inFont:NSFont) -> CGFloat
        {
        return(70)
        }
    }

