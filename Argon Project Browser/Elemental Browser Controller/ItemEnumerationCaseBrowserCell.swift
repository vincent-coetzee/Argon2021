//
//  ItemEnumerationCaseBrowserCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/11.
//

import Cocoa

public class ItemEnumerationCaseBrowserCell:ItemBrowserCell
    {
    private let enumerationCase:EnumerationCase
    
    public override var textColor:NSColor
        {
        return(.argonNamingYellow)
        }

    public override var title:String
        {
        return(self.enumerationCase.symbol)
        }
        
    public override var icon:NSImage
        {
        let image = self.enumerationCase.icon
        let newImage = image.tintedWith(self.textColor)
        return(newImage)
//        return(self.symbol.icon.coloredWith(color: self.textColor).resized(to: NSSize(width:Self.kRowHeight,height:Self.kRowHeight)))
        }
        
    init(enumerationCase:EnumerationCase)
        {
        self.enumerationCase = enumerationCase
        super.init()
        }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
