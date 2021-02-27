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
    
public class ItemEditorCell:NSView,Framed
    {
    internal var item:EditableItem
    public var layoutFrame:LayoutFrame = .zero
    
    init(item:EditableItem)
        {
        self.item = item
        super.init(frame:.zero)
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

