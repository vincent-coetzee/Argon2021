//
//  ArgonFileItemBrowserCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public class ItemFileBrowserCell:ItemBrowserCell
    {
    public override var textColor:NSColor
        {
        return(.argonSizzlingRed)
        }
        
    private let fileItem:ArgonFile
    
    public override var title:String
        {
        return(self.fileItem.title)
        }
        
    public override var icon:NSImage
        {
        return(self.fileItem.icon.tintedWith(self.textColor))
        }
        
    init(item:Elemental)
        {
        self.fileItem = item as! ArgonFile
        super.init()
        self.layoutFrame = .sizeToBounds
        }
        
    required init()
        {
        fatalError("init() has not been implemented")
        }
    
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    }
