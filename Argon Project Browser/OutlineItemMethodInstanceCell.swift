//
//  OutlineItemMethodInstanceCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

public class OutlineItemMethodInstanceCell:OutlineItemCell
    {
    public let nameView = NSTextField(frame:.zero)
    public let iconView = NSImageView(frame:.zero)
    
    private let methodInstance:MethodInstance
    
    required init(symbol:Symbol)
        {
        self.methodInstance = symbol as! MethodInstance
        super.init(symbol:symbol)
        self.addClassNameView()
        self.addIconView()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addClassNameView()
        {
        self.addSubview(self.nameView)
        self.nameView.frame = NSRect(x:Self.kRowHeight,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        self.nameView.stringValue = self.methodInstance.shortName + self.methodInstance.parameterDisplayString
        self.nameView.font = Self.kDefaultFont
        self.nameView.drawsBackground = false
        self.nameView.isBezeled = false
        self.nameView.textColor = NSColor.sizzlingRed
        }
        
    private func addIconView()
        {
        self.addSubview(self.iconView)
        self.iconView.image = methodInstance.image
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        }
        
    public override func layout()
        {
        super.layout()
        let rect = self.frame
        self.nameView.frame = NSRect(x:Self.kRowHeight,y:-6,width:rect.size.width - Self.kRowHeight,height:Self.kRowHeight)
        self.iconView.frame = NSRect(x:0,y:0,width:Self.kRowHeight,height:Self.kRowHeight)
        }
    }
