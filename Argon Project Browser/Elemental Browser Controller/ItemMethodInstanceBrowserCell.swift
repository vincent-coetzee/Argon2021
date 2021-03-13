//
//  OutlineItemMethodInstanceCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

public class ItemMethodInstanceBrowserCell:ItemBrowserCell
    {
    public override var textColor:NSColor
        {
            return(StylePalette.shared.methodStyle.color)
        }
    
    public override var title:String
        {
        return(self.symbol.shortName)
        }
        
    public override var icon:NSImage
        {
        return(self.symbol.icon.coloredWith(color: self.textColor).resized(to:NSSize(width:Self.kRowHeight,height:Self.kRowHeight)))
        }
        
    private let methodInstance:MethodInstance
    private let symbol:Symbol
    
    required init(symbol:Symbol)
        {
        self.symbol = symbol
        self.methodInstance = symbol as! MethodInstance
        super.init()
        }
    
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    
    required init()
        {
        fatalError("init() has not been implemented")
        }
    }
