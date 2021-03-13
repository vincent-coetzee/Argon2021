//
//  OutlineItemClassCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

public class ItemClassBrowserCell:ItemBrowserCell
    {        
    public override var textColor:NSColor
        {
        if self.symbol is SystemPlaceholderClass
            {
            return(.argonNeonOrange)
            }
        else if self.symbol is Class
            {
            return(.argonNeonPink)
            }
        else
            {
            return(.white)
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
        
    private let symbol:Symbol
    
    required init(symbol:Symbol)
        {
        self.symbol = symbol
        super.init()
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
    }
