//
//  ItemConstantBrowserCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/11.
//

import Cocoa

public class ItemConstantBrowserCell:ItemBrowserCell
    {
    private let constant:Constant
    
    public override var textColor:NSColor
        {
        return(.argonNeonGreen)
        }

    public override var title:String
        {
        return(self.constant.shortName + " = " + (self.constant.initialValue?.stringValue ?? ""))
        }
        
    public override var icon:NSImage
        {
        let image = self.constant.icon
        let newImage = image.tintedWith(self.textColor)
        return(newImage)
//        return(self.symbol.icon.coloredWith(color: self.textColor).resized(to: NSSize(width:Self.kRowHeight,height:Self.kRowHeight)))
        }
        
    init(constant:Constant)
        {
        self.constant = constant
        super.init()
        }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

