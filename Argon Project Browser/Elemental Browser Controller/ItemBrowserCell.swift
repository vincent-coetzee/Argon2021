//
//  OutlineItemCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/23.
//

import Foundation
import AppKit


public class ItemCell:NSTableCellView
    {
    }
    
public class ItemBrowserCell:ItemCell
    {
    internal func cachedImage(for symbol:Symbol) -> NSImage
        {
        return(symbol.icon.tintedWith(self.textColor).resized(to: NSSize(width:Self.kRowHeight,height:Self.kRowHeight)))
        }
        
    public var textColor:NSColor
        {
        return(.white)
        }
        
    public var title:String
        {
        return("ItemBrowserCell")
        }
        
    public var icon:NSImage
        {
        return(NSImage(named:"IconNull64")!.coloredWith(color: NSColor.argonNeonPink))
        }
        
    internal let iconView = NSImageView(frame:.zero)
    internal let titleView = NSTextField(frame:.zero)
    
    required init()
        {
        super.init(frame:.zero)
        self.addIconView()
        self.addTitleView()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static let kDefaultFont = NSFont(name:"SunSans-Demi",size:12)!
    public static let kRowHeight:CGFloat = 18
    public static let kSlotRowHeight:CGFloat = 24
    
    public func menu(for event:NSEvent,in row:Int,on item:Elemental) -> NSMenu?
        {
        return(nil)
        }
        
    public func textAlignmentInCell(_ text:String) -> CGFloat
        {
        let string = NSAttributedString(string:text,attributes:[.font:Self.kDefaultFont])
        let size = string.size()
        return((Self.kRowHeight - size.height) / 2)
        }
        
    private func addIconView()
        {
        self.addSubview(self.iconView)
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.iconView.image = self.icon
        }
        
    private func addTitleView()
        {
        self.addSubview(self.titleView)
        self.titleView.frame = NSRect(x:Self.kRowHeight,y:-self.textAlignmentInCell(self.titleView.stringValue),width:Self.kRowHeight,height:Self.kRowHeight)
        self.titleView.stringValue = self.title
        self.titleView.font = Self.kDefaultFont
        self.titleView.drawsBackground = false
        self.titleView.isBezeled = false
        self.titleView.textColor = self.textColor
        self.titleView.isEditable = false
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.frame
        self.titleView.frame = NSRect(x:Self.kRowHeight,y:-self.textAlignmentInCell(self.titleView.stringValue),width:rect.size.width - Self.kRowHeight,height:Self.kRowHeight)
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        }
        
    public func layout(inView:NSView)
        {
        let rect = self.bounds
        self.titleView.frame = NSRect(x:Self.kRowHeight,y:-self.textAlignmentInCell(self.titleView.stringValue),width:rect.size.width - Self.kRowHeight,height:Self.kRowHeight)
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        }
    }


public class ItemListCell:ItemCell
    {
    public static let kDefaultFont = NSFont(name:"SunSans-Demi",size:12)!
    public static let kRowHeight:CGFloat = 18
    
    init()
        {
        super.init(frame:.zero)
        }
        
    public func menu(for event:NSEvent,in row:Int,on item:Elemental) -> NSMenu?
        {
        return(nil)
        }
        
    public func textAlignmentInCell(_ text:String) -> CGFloat
        {
        let string = NSAttributedString(string:text,attributes:[.font:Self.kDefaultFont])
        let size = string.size()
        return((Self.kRowHeight - size.height) / 2)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
