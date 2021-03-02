//
//  OutlineItemClassCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

public class ItemClassBrowserCell:ItemBrowserCell
    {
    private static var _cachedIcon:NSImage?
    
    private static func cachedIcon(for symbol:Symbol) -> NSImage
        {
        if self._cachedIcon == nil
            {
            self._cachedIcon = symbol.icon.coloredWith(color:NSColor.argonNeonOrange)
            }
        return(self._cachedIcon!)
        }
        
    public let nameView = NSTextField(frame:.zero)
    public let iconView = NSImageView(frame:.zero)
    
    private let symbol:Symbol
    
    required init(symbol:Symbol)
        {
        self.symbol = symbol
        super.init()
        self.addClassNameView()
        self.addIconView()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    public override func menu(for event:NSEvent,in row:Int,on item:Elemental) -> NSMenu?
        {
        let menu = NSMenu(title: "Classes")
        var item = menu.addItem(withTitle: "New Class", action: #selector(onNewClassClicked), keyEquivalent: "C")
        item.keyEquivalentModifierMask = [.command,.shift]
        item.target = self
        item = menu.addItem(withTitle: "New Slot", action: #selector(onNewSlotClicked), keyEquivalent: "S")
        item.keyEquivalentModifierMask = [.command,.shift]
        item.target = self
        item = menu.addItem(withTitle: "New Class Slot", action: #selector(onNewClassSlotClicked), keyEquivalent: "L")
        item.keyEquivalentModifierMask = [.command,.shift]
        item.target = self
        menu.addItem(NSMenuItem.separator())
        item = menu.addItem(withTitle: "Delete Class", action: #selector(onDeleteClassClicked), keyEquivalent: "Y")
        item.keyEquivalentModifierMask = [.command,.shift]
        item.target = self
        return(menu)
        }
        
    @IBAction func onNewClassClicked(_ sender:Any?)
        {
        }
        
    @IBAction func onDeleteClassClicked(_ sender:Any?)
        {
        }
        
    @IBAction func onNewSlotClicked(_ sender:Any?)
        {
        }
        
    @IBAction func onNewClassSlotClicked(_ sender:Any?)
        {
        }
        
    private func addClassNameView()
        {
        self.addSubview(self.nameView)
        self.nameView.frame = NSRect(x:Self.kRowHeight,y:-self.textAlignmentInCell(self.nameView.stringValue),width:Self.kRowHeight,height:Self.kRowHeight)
        self.nameView.stringValue = self.symbol.completeName
        self.nameView.font = Self.kDefaultFont
        self.nameView.drawsBackground = false
        self.nameView.isBezeled = false
        self.nameView.textColor = NSColor.argonNeonOrange
        }
        
    private func addIconView()
        {
        self.addSubview(self.iconView)
        let icon = Self.cachedIcon(for:self.symbol)
        self.iconView.image = icon
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.frame
        self.nameView.frame = NSRect(x:Self.kRowHeight,y:-self.textAlignmentInCell(self.nameView.stringValue),width:rect.size.width - Self.kRowHeight,height:Self.kRowHeight)
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        }
    }
