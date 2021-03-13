//
//  HeadingRowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/08.
//

import Cocoa

public class TitledGroupRowWrapper:RowWrapper
    {
    public override var isExpandable:Bool
        {
        return(true)
        }
        
    public let title:String
    
    public var children:Array<RowWrapper> = []
        
    public override func rowView() -> NSView
        {
        let view = NSTextField(frame:.zero)
        view.isBezeled = false
        view.stringValue = self.title
        view.textColor = NSColor.argonLime
        view.font = Self.kDefaultFont
        return(view)
        }
        
    public override var rowHeight:CGFloat
        {
        return(18)
        }
        
    public override var count:Int
        {
        return(self.children.count)
        }
        
    public override func child(atIndex index:Int) -> RowWrapper
        {
        return(self.children[index])
        }
        
    init(title:String,children:Array<RowWrapper> = [])
        {
        self.title = title
        self.children = children
        super.init()
        }
    }
