//
//  ItemEnumerationBrowserCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/11.
//

import Cocoa

public class ItemEnumerationBrowserCell:ItemBrowserCell
    {
    private let enumeration:Enumeration
    
    public override var textColor:NSColor
        {
        return(.argonNamingYellow)
        }

    public override var title:String
        {
        return(self.enumeration.shortName)
        }
        
    public override var icon:NSImage
        {
        let image = self.enumeration.icon
        let newImage = image.tintedWith(self.textColor)
        return(newImage)
//        return(self.symbol.icon.coloredWith(color: self.textColor).resized(to: NSSize(width:Self.kRowHeight,height:Self.kRowHeight)))
        }
        
    init(enumeration:Enumeration)
        {
        self.enumeration = enumeration
        super.init()
        }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
