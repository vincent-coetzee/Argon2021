//
//  IconTitleCelll.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Cocoa

public enum CellKind
    {
    case imageTitleCell
    case slotCell
    }
    
public class IconTitleCell:NSBrowserCell
    {
    public var cellKind:CellKind = .imageTitleCell
    public var item:Any?
    public var index:Int = 0
    
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
        if self.cellKind == .slotCell
            {
            self.drawSlots()
            }
        else
            {
            super.drawInterior(withFrame:cellFrame,in:controlView)
            }
//        let iconSize = self.image?.size ?? .zero
//        let cellSize = cellFrame.size
//        let iconFrame = NSRect(x:cellFrame.origin.x,y:cellFrame.origin.y,width:iconSize.width,height:cellSize.height)
//        self.image?.draw(in:iconFrame)
//        let newFrame = NSRect(x:iconSize.width,y:cellFrame.origin.y,width: cellSize.width - iconSize.width,height:cellSize.height)
//        super.drawInterior(withFrame: cellFrame,in:controlView)
        }
        
    private func drawSlots()
        {
        let aClass = item as! Class
        
        }
    }
