//
//  OutlineItemSymbolCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

public class OutlineItemSymbolCell:OutlineItemCell
    {
    internal let symbol:Symbol
    internal let iconView = NSImageView(frame:.zero)
    internal let titleView = NSTextField(frame:.zero)
    
    required init(symbol:Symbol)
        {
        self.symbol = symbol
        super.init(symbol:symbol)
        self.addIconView()
        self.addTitleView()
        }
    
    public var rowHeight:CGFloat
        {
        return(Self.kRowHeight)
        }
        
    private func addIconView()
        {
        self.addSubview(self.iconView)
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.iconView.image = symbol.image.resized(to:NSSize(width:Self.kRowHeight,height:Self.kRowHeight))
        }
        
    private func addTitleView()
        {
        self.addSubview(self.titleView)
        self.titleView.frame = NSRect(x:Self.kRowHeight,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.titleView.stringValue = self.symbol.shortName + " \(Swift.type(of:symbol))"
        self.titleView.font = Self.kDefaultFont
        self.titleView.drawsBackground = false
        self.titleView.isBezeled = false
        if symbol is Module
            {
            self.titleView.textColor = NSColor.lime
            }
        else if symbol is Class
            {
            self.titleView.textColor = NSColor.neonOrange
            }
        else if symbol is Method
            {
            self.titleView.textColor = NSColor.sizzlingRed
            }
        else if symbol is Enumeration
            {
            self.titleView.textColor = NSColor.neonPink
            }
        else if symbol is Slot
            {
            self.titleView.textColor = NSColor.cheese
            }
        else
            {
            self.titleView.textColor = NSColor.lightGray
            }
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.frame
        self.titleView.frame = NSRect(x:Self.kRowHeight + 4,y:-6,width:rect.size.width-Self.kRowHeight,height:Self.kRowHeight)
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
