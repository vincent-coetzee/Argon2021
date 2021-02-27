//
//  OutlineItemCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/23.
//

import Foundation
import AppKit

public class ItemBrowserCell:NSTableCellView
    {
    required init()
        {
        super.init(frame:.zero)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static let kDefaultFont = NSFont(name:"SunSans-Demi",size:12)!
    public static let kRowHeight:CGFloat = 24
    
    public func menu(for event:NSEvent,in row:Int,on item:BrowsableItem) -> NSMenu?
        {
        return(nil)
        }
    }

