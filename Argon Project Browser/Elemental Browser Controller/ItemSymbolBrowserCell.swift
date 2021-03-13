//
//  OutlineItemSymbolCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

public class ItemSymbolBrowserCell:ItemBrowserCell
    {
    public override var textColor:NSColor
        {
        if self.symbol is Constant
            {
            return(.argonNeonGreen)
            }
        else if self.symbol is Module
            {
            return(.argonKeywordGreen)
            }
        else if self.symbol is Class
            {
            return(StylePalette.shared.classStyle.color)
            }
        else if self.symbol is SystemPlaceholderClass
            {
            return(StylePalette.shared.placeholderClassStyle.color)
            }
        else if self.symbol is Method || self.symbol is MethodInstance || self.symbol is SystemPlaceholderMethod || self.symbol is SystemPlaceholderMethodInstance
            {
            return(StylePalette.shared.methodStyle.color)
            }
        else
            {
            return(NSColor.white)
            }
        }
        
    public override var title:String
        {
        return(self.symbol.completeName)
        }
        
    public override var icon:NSImage
        {
        let image = self.symbol.icon
        let newImage = image.tintedWith(self.textColor)
        return(newImage)
//        return(self.symbol.icon.coloredWith(color: self.textColor).resized(to: NSSize(width:Self.kRowHeight,height:Self.kRowHeight)))
        }
        
    internal let symbol:Symbol
    
    required init(symbol:Symbol)
        {
        self.symbol = symbol
        super.init()
        }
    
    public var rowHeight:CGFloat
        {
        return(Self.kRowHeight)
        }
        
    private var elementalColor:NSColor
        {
        if symbol is Module
            {
            return(NSColor.argonLime)
            }
        else if symbol is Class
            {
            return(NSColor.argonNeonOrange)
            }
        else if symbol is Method
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
            return(NSColor.lightGray)
            }
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
