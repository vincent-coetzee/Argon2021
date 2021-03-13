//
//  ItemEditorCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public protocol EditableItem
    {
    var title:String { get }
    var icon:NSImage { get }
    }
    
public class DefaultEditorItem:NSView,EditableItem
    {        
    public var title:String
        {
        return("")
        }
        
    public var icon:NSImage
        {
        return(NSImage())
        }
    }
    
public class ItemEditorCell:ItemCell
    {
    internal var item:EditableItem = DefaultEditorItem()
    
    init(item:EditableItem)
        {
        self.item = item
        super.init(frame:.zero)
        }
        
    override init(frame:NSRect)
        {
        super.init(frame:frame)
        }
        
    public func reload()
        {
        }
        
    public func layout(inView view:NSView)
        {
        self.layoutFrame = .sizeToBounds
        self.frame = self.layoutFrame.frame(in: view.frame)
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

