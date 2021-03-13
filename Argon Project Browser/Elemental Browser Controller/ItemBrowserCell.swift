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
    private static var cachedImages:[SymbolKind:NSImage] = [:]
    
    internal func cachedImage(for symbol:Symbol) -> NSImage
        {
        let kind = symbol.symbolKind
        if let image = Self.cachedImages[kind]
            {
            return(image)
            }
        let image = symbol.icon.coloredWith(color: self.textColor).resized(to: NSSize(width:Self.kRowHeight,height:Self.kRowHeight))
        Self.cachedImages[kind] = image
        return(image)
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


public class ItemElementalListCell:ItemListCell
    {
    public var size:NSSize = .zero
    private var list:ElementalList
    private var textColor:NSColor
    private var elements:Array<CATextLayer> = []
    
    init(_ list:ElementalList,textColor:NSColor)
        {
        self.list = list
        self.textColor = textColor
        let attributes:Dictionary<NSAttributedString.Key,Any> = [.font:Self.kDefaultFont]
        let string1 = NSAttributedString(string:list.title,attributes:attributes)
        var size1 = string1.size()
        let titleLayer = CATextLayer()
        titleLayer.font = Self.kDefaultFont
        titleLayer.frame = NSPoint.zero.extent(size1)
        titleLayer.string = list.title
        super.init()
        self.wantsLayer = true
        self.layer?.addSublayer(titleLayer)
        elements.append(titleLayer)
        for elemental in list
            {
            let string = NSAttributedString(string:elemental.title,attributes:attributes)
            let size2 = string.size()
            size1 += size2
            let layer = CATextLayer()
            layer.string = elemental.title
            layer.font = Self.kDefaultFont
            layer.fontSize = Self.kDefaultFont.pointSize
            self.elements.append(layer)
            self.layer?.addSublayer(layer)
            layer.frame = NSPoint.zero.extent(size2)
            }
        self.size = size1
        }
        
    public override func layout()
        {
        super.layout()
        var point:NSPoint = .zero
        let myBounds = self.bounds
        for layer in self.elements
            {
            layer.frame = point.extent(layer.frame.size)
            point.y += layer.frame.size.height
            }
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
