//
//  OutlineItemSymbolCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

public class ItemSymbolBrowserCell:ItemBrowserCell
    {
    internal let symbol:Symbol
    internal let iconView = NSImageView(frame:.zero)
    internal let titleView = NSTextField(frame:.zero)
    
    required init(symbol:Symbol)
        {
        self.symbol = symbol
        super.init()
        self.addIconView()
        self.addTitleView()
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
        
    private func addIconView()
        {
        self.addSubview(self.iconView)
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.iconView.image = symbol.icon.resized(to:NSSize(width:Self.kRowHeight,height:Self.kRowHeight)).coloredWith(color:self.elementalColor)
        }
        
    private func addTitleView()
        {
        self.addSubview(self.titleView)
        self.titleView.frame = NSRect(x:Self.kRowHeight,y:-self.textAlignmentInCell(self.titleView.stringValue),width:Self.kRowHeight,height:Self.kRowHeight)
        self.titleView.stringValue = self.symbol.completeName
        self.titleView.font = Self.kDefaultFont
        self.titleView.drawsBackground = false
        self.titleView.isBezeled = false
        self.titleView.textColor = self.elementalColor
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.frame
        self.titleView.frame = NSRect(x:Self.kRowHeight + 4,y:-self.textAlignmentInCell(self.titleView.stringValue),width:rect.size.width-Self.kRowHeight,height:Self.kRowHeight)
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
