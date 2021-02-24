//
//  OutlineItemCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/23.
//

import Foundation
import AppKit

public class OutlineItemCell:NSView
    {
    required init(symbol:Symbol)
        {
        symbol.buildSymbols()
        super.init(frame:.zero)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static let kDefaultFont = NSFont(name:"SunSans-Demi",size:12)!
    public static let kRowHeight:CGFloat = 24
    }
    
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

public class OutlineItemSlotCell:OutlineItemCell
    {
    private let slot:Slot
    private let trashButton = NSButton(frame:.zero)
    private let slotNameView = NSTextField(frame:.zero)
    private let slotTypeView = NSTextField(frame:.zero)
    private let addButton = NSButton(frame:.zero)
    
    required init(symbol:Symbol)
        {
        self.slot = symbol as! Slot
        super.init(symbol:symbol)
        self.addSlotNameView()
        self.addSlotTypeView()
        self.addTrashButton()
        if self.slot.isLastSlot
            {
            self.addAddButton()
            }
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTrashButton()
        {
        self.addSubview(trashButton)
        self.trashButton.image = NSImage(systemSymbolName:"trash.fill",accessibilityDescription:nil)
        self.trashButton.frame = NSRect(x:Self.kRowHeight,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.trashButton.isBordered = false
        }
        
    private func addAddButton()
        {
        self.addSubview(self.addButton)
        self.addButton.image = NSImage(systemSymbolName:"plus.app",accessibilityDescription:nil)
        self.addButton.frame = NSRect(x:Self.kRowHeight,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.addButton.isBordered = false
        }
        
    private func addSlotNameView()
        {
        self.addSubview(self.slotNameView)
        self.slotNameView.frame = NSRect(x:Self.kRowHeight,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.slotNameView.stringValue = self.slot.shortName
        self.slotNameView.font = Self.kDefaultFont
        self.slotNameView.drawsBackground = false
        self.slotNameView.isBezeled = false
        self.slotNameView.textColor = NSColor.cheese
        }
        
    private func addSlotTypeView()
        {
        self.addSubview(self.slotTypeView)
        self.slotTypeView.frame = NSRect(x:Self.kRowHeight,y:0,width:Self.kRowHeight - Self.kRowHeight,height:Self.kRowHeight)
        self.slotTypeView.stringValue = self.slot.typeClass.shortName
        self.slotTypeView.font = Self.kDefaultFont
        self.slotTypeView.drawsBackground = false
        self.slotTypeView.isBezeled = false
        self.slotTypeView.textColor = NSColor.cheese
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.frame
        let width = (rect.size.width - Self.kRowHeight) / 3.0
        self.trashButton.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.slotNameView.frame = NSRect(x:Self.kRowHeight,y:-6,width:width,height:Self.kRowHeight)
        self.slotTypeView.frame = NSRect(x:Self.kRowHeight + width,y:-6,width:(width*2.0) - Self.kRowHeight - 4,height:Self.kRowHeight)
        if self.slot.isLastSlot
            {
            self.addButton.frame = NSRect(x:rect.size.width - Self.kRowHeight - 2,y:-6,width:Self.kRowHeight,height:Self.kRowHeight)
            }
        }
    }

public class OutlineItemClassCell:OutlineItemCell
    {
    public let nameView = NSTextField(frame:.zero)
    
    private let symbol:Symbol
    
    required init(symbol:Symbol)
        {
        self.symbol = symbol
        super.init(symbol:symbol)
        self.addClassNameView()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addClassNameView()
        {
        self.addSubview(self.nameView)
        self.nameView.frame = NSRect(x:Self.kRowHeight,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.nameView.stringValue = self.symbol.shortName
        self.nameView.font = Self.kDefaultFont
        self.nameView.drawsBackground = false
        self.nameView.isBezeled = false
        self.nameView.textColor = NSColor.cheese
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.frame
        self.nameView.frame = NSRect(x:0,y:-6,width:rect.size.width,height:Self.kRowHeight)
        }
    }
