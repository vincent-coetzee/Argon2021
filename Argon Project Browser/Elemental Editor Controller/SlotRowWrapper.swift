//
//  SlotRowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/08.
//

import Cocoa

public class SlotRowWrapper:RowWrapper
    {
    private let slot:Slot
    private var classPopup:NSPopUpButton?
    
    public override var isExpandable:Bool
        {
        return(false)
        }
        
    public override func rowView() -> NSView
        {
        let container = OutlinerRowView(frame:.zero)
        self.makeIcon(container:container)
        self.makeLabel(container:container)
        self.makePopup(container:container)
        self.makePlusButton(container:container)
        self.makeTrashButton(container:container)
        return(container)
        }
        
    public override var rowHeight:CGFloat
        {
        return(Self.kRowHeight)
        }
        
    init(slot:Slot)
        {
        self.slot = slot
        super.init()
        self.primaryColor = .argonSeaGreen
        }

    private func makeIcon(container:OutlinerRowView)
        {
        let view = NSImageView(frame:.zero)
        container.addFramedView(view)
        view.layoutFrame = LayoutFrame.square(18)
        view.image = NSImage(named:"IconSlot64")!.tintedWith(NSColor.argonSeaGreen).resized(to:NSSize(width:18,height:18))
        }
        
    private func makeLabel(container:OutlinerRowView)
        {
        let view = NSTextField(frame:.zero)
        container.addFramedView(view)
        let textSize = self.measureText(slot.shortName)
        let delta = (self.rowHeight - textSize.height)/2.0
        view.layoutFrame = LayoutFrame(left:0,18,top:0,-delta,right:0.5,-18,bottom:1,-delta)
        view.font = Self.kDefaultFont
        view.alignment = .right
        view.isBezeled = false
        view.isEditable = false
        view.textColor = NSColor.argonSeaGreen
        view.backgroundColor = NSColor.clear
        view.stringValue = slot.shortName
        view.wantsLayer = true
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor.red.cgColor
        }
        
    private func makePopup(container:OutlinerRowView)
        {
        let view = NSPopUpButton(frame:.zero,pullsDown:false)
        container.addFramedView(view)
        view.layoutFrame = LayoutFrame(left:0.5,-18,top:0,0,right:1.0,-36,bottom:1,0)
        view.font = Self.kDefaultFont
        view.contentTintColor = self.primaryColor
        view.addItems(withTitles: self.allClassNames())
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor.red.cgColor
        self.classPopup = view
        let slotClass = slot.typeClass.completeName
        view.setTitle(slotClass)
        }
        
    private func makeTrashButton(container:OutlinerRowView)
        {
        let trashButton = NSButton(image:NSImage(systemSymbolName: "trash.circle", accessibilityDescription: nil)!,target:self,action:#selector(onTrashClicked))
        trashButton.isBordered = false
        trashButton.bezelStyle = .circular
        container.addFramedView(trashButton)
        trashButton.layoutFrame = LayoutFrame(left:1,-36,top:0,0,right:1,-18,bottom:1,0)
        trashButton.wantsLayer = true
        trashButton.layer?.borderWidth = 1
        trashButton.layer?.borderColor = NSColor.red.cgColor
        }
        
    private func makePlusButton(container:OutlinerRowView)
        {
        let plusButton = NSButton(image:NSImage(systemSymbolName: "plus.circle", accessibilityDescription: nil)!,target:self,action:#selector(onPlusClicked))
        plusButton.isBordered = false
        plusButton.bezelStyle = .circular
        container.addFramedView(plusButton)
        plusButton.layoutFrame = LayoutFrame(left:1,-18,top:0,0,right:1,0,bottom:1,0)
        plusButton.wantsLayer = true
        plusButton.layer?.borderWidth = 1
        plusButton.layer?.borderColor = NSColor.red.cgColor
        }
        
    @IBAction func onTrashClicked(_ sender:Any?)
        {
        }
        
    @IBAction func onPlusClicked(_ sender:Any?)
        {
        }
        
    private func allClassNames() -> Array<String>
        {
        let rootClass = Module.argonModule.lookupClass("Root")!
        let allSubclasses = rootClass.allSubclasses
        return(allSubclasses.map{$0.completeName}.sorted{$0<$1})
        }
    }

extension NSView:Framed
    {
    private struct AssociatedKeys
        {
        static var key = "layoutFrame_Key"
        }
        
    public var layoutFrame:LayoutFrame
        {
        get
            {
            return objc_getAssociatedObject(self, &AssociatedKeys.key) as! LayoutFrame
            }
        set
            {
            objc_setAssociatedObject(self, &AssociatedKeys.key, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
    public var outlinerView:NSOutlineView?
        {
        if self.superview == nil
            {
            return(nil)
            }
        if self.superview! is NSOutlineView
            {
            return(self.superview! as! NSOutlineView)
            }
        return(self.superview!.outlinerView)
        }
    }
