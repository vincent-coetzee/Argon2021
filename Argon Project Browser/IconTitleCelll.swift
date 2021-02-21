//
//  IconTitleCelll.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Cocoa

public class IconTitleCell:NSBrowserCell
    {
    override init(textCell:String)
        {
        super.init(textCell:textCell)
        }
        
    init(title:String,icon:NSImage)
        {
        super.init(textCell: title)
        self.title = title
        self.image = icon
        }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView)
        {
//        let iconSize = self.image?.size ?? .zero
//        let cellSize = cellFrame.size
//        let iconFrame = NSRect(x:cellFrame.origin.x,y:cellFrame.origin.y,width:iconSize.width,height:cellSize.height)
//        self.image?.draw(in:iconFrame)
//        let newFrame = NSRect(x:iconSize.width,y:cellFrame.origin.y,width: cellSize.width - iconSize.width,height:cellSize.height)
//        super.drawInterior(withFrame: cellFrame,in:controlView)
        }
    }
