//
//  OutlineItemCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/23.
//

import Foundation
import AppKit

public class OutlineItemCell:NSView
    {
    public static let defaultFont = NSFont(name:"SunSans-Demi",size:14)!
    
    private let symbol:Symbol
    private let iconView = NSImageView(frame:.zero)
    private let titleView = NSTextField(frame:.zero)
    
    required init(symbol:Symbol)
        {
        self.symbol = symbol
        super.init(frame:.zero)
        self.addIconView()
        self.addTitleView()
        }
    
    public var rowHeight:CGFloat
        {
        return(32)
        }
        
    private func addIconView()
        {
        self.addSubview(self.iconView)
        self.iconView.frame = NSRect(x:0,y:0,width:32,height:32)
        self.iconView.image = symbol.image.resized(to:NSSize(width:32,height:32))
        }
        
    private func addTitleView()
        {
        self.addSubview(self.titleView)
        self.titleView.frame = NSRect(x:32,y:0,width:32,height:32)
        self.titleView.stringValue = self.symbol.shortName
        self.titleView.font = Self.defaultFont
        self.titleView.drawsBackground = false
        self.titleView.isBezeled = false
        if symbol is Module
            {
            self.titleView.textColor = NSColor.lime
            }
        else if symbol is Class
            {
            self.titleView.textColor = NSColor.neonOrange
            }
        else if symbol is Method
            {
            self.titleView.textColor = NSColor.cheese
            }
        else
            {
            self.titleView.textColor = NSColor.lightGray
            }
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.frame
        self.titleView.frame = NSRect(x:32,y:0,width:rect.size.width-32,height:24)
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
