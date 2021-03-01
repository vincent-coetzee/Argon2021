//
//  OutlineItemSlotCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

public class OutlineItemSlotCell:ItemBrowserCell
    {
    private let slot:Slot
    private let trashButton = NSButton(frame:.zero)
    private let slotNameView = NSTextField(frame:.zero)
    private let slotTypeView = NSTextField(frame:.zero)
    private let addButton = NSButton(frame:.zero)
    private let iconView = NSImageView(frame:.zero)
    
    required init(symbol:Symbol)
        {
        self.slot = symbol as! Slot
        super.init()
        self.addIconView()
        self.addSlotNameView()
//        self.addSlotTypeView()
        self.addTrashButton()
        if self.slot.isLastSlot
            {
            self.addAddButton()
            }
        self.wantsLayer = true
        self.layer?.borderWidth = 1
        self.layer?.borderColor = NSColor.argonSexyPink.cgColor
        self.layer?.cornerRadius = 8
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @IBAction func onAddClicked(_ sender:Any?)
        {
        print()
        }
        
    @IBAction func onDeleteClicked(_ sender:Any?)
        {
        print()
        }
        
    private func addTrashButton()
        {
        self.addSubview(trashButton)
        self.trashButton.image = NSImage(systemSymbolName:"trash.fill",accessibilityDescription:nil)
        self.trashButton.frame = NSRect(x:Self.kSlotRowHeight * 2,y:0,width:Self.kSlotRowHeight,height:Self.kSlotRowHeight)
        self.trashButton.isBordered = false
        self.trashButton.target = self
        self.trashButton.action = #selector(onDeleteClicked)
        }
        
    private func addIconView()
        {
        self.addSubview(self.iconView)
        self.iconView.image = slot.icon
        self.iconView.frame = NSRect(x:Self.kSlotRowHeight,y:0,width:Self.kSlotRowHeight,height:Self.kSlotRowHeight)
        }
        
    private func addAddButton()
        {
        self.addSubview(self.addButton)
        self.addButton.image = NSImage(systemSymbolName:"plus.app",accessibilityDescription:nil)
        self.addButton.frame = NSRect(x:Self.kSlotRowHeight,y:0,width:Self.kSlotRowHeight,height:Self.kSlotRowHeight)
        self.addButton.isBordered = false
        self.addButton.action = #selector(onAddClicked)
        self.addButton.target = self
        }
        
    private func addSlotNameView()
        {
        self.addSubview(self.slotNameView)
        self.slotNameView.frame = NSRect(x:Self.kSlotRowHeight,y:-self.textAlignmentInCell(self.slotNameView.stringValue),width:Self.kSlotRowHeight,height:Self.kSlotRowHeight)
        self.slotNameView.stringValue = self.slot.shortName + " :: " + self.slot.typeClass.shortName
        self.slotNameView.font = Self.kDefaultFont
        self.slotNameView.drawsBackground = false
        self.slotNameView.isBezeled = false
        self.slotNameView.textColor = NSColor.argonSexyPink
        }
        
    private func addSlotTypeView()
        {
        self.addSubview(self.slotTypeView)
        self.slotTypeView.frame = NSRect(x:Self.kSlotRowHeight,y:0,width:Self.kSlotRowHeight - Self.kSlotRowHeight,height:Self.kSlotRowHeight)
        self.slotTypeView.stringValue = self.slot.typeClass.shortName
        self.slotTypeView.font = Self.kDefaultFont
        self.slotTypeView.drawsBackground = false
        self.slotTypeView.isBezeled = false
        self.slotTypeView.textColor = NSColor.argonSexyPink
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.frame
        let width = (rect.size.width - Self.kSlotRowHeight*3)
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kSlotRowHeight,height:Self.kSlotRowHeight)
        self.trashButton.frame = NSRect(x:rect.size.width - Self.kSlotRowHeight*2,y:0,width:Self.kSlotRowHeight,height:Self.kSlotRowHeight)
        self.slotNameView.frame = NSRect(x:Self.kSlotRowHeight,y:-self.textAlignmentInCell(self.slotNameView.stringValue),width:width,height:Self.kSlotRowHeight)
//        self.slotTypeView.frame = NSRect(x:Self.kSlotRowHeight + Self.kSlotRowHeight + width,y:-6,width:(width*2.0) - Self.kSlotRowHeight - 4,height:Self.kSlotRowHeight)
        if self.slot.isLastSlot
            {
            self.addButton.frame = NSRect(x:rect.size.width - Self.kSlotRowHeight,y:0,width:Self.kSlotRowHeight,height:Self.kSlotRowHeight)
            }
        }
        
    public override func textAlignmentInCell(_ text:String) -> CGFloat
        {
        let string = NSAttributedString(string:text,attributes:[.font:Self.kDefaultFont])
        let size = string.size()
        return((Self.kSlotRowHeight - size.height) / 2)
        }
    }
