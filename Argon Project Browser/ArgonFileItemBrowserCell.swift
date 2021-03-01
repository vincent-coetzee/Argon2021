//
//  ArgonFileItemBrowserCell.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public class ArgonFileItemBrowserCell:ItemBrowserCell,Framed
    {
    private let fileItem:ArgonFile
    private let iconPane = NSImageView(frame:.zero)
    private let titlePane = NSTextField(frame: .zero)
    
    public var layoutFrame:LayoutFrame
    
    init(item:BrowsableItem)
        {
        self.layoutFrame = .sizeToBounds
        self.fileItem = item as! ArgonFile
        super.init()
        self.initPanes()
        }
    
    private func initPanes()
        {
        self.addSubview(iconPane)
        self.addSubview(titlePane)
        iconPane.image = NSImage(named:"IconFile64")!.resized(to: NSSize(width:Self.kRowHeight,height:Self.kRowHeight))
        titlePane.font = StylePalette.kDefaultFont
        titlePane.textColor = NSColor.argonSizzlingRed
        titlePane.isBezeled = false
        titlePane.drawsBackground = false
        titlePane.stringValue = fileItem.title
        }
        
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func layout(inView:NSView)
        {
        super.layout()
        self.frame = inView.bounds
        self.iconPane.frame = NSPoint.zero.extent(NSSize(width:Self.kRowHeight,height:Self.kRowHeight))
        self.titlePane.frame = NSPoint(x:Self.kRowHeight,y: -self.textAlignmentInCell(self.titlePane.stringValue)).extent(NSSize(width:self.bounds.size.width - Self.kRowHeight,height:Self.kRowHeight))
        }
        
    public override func layout()
        {
        super.layout()
        self.iconPane.frame = NSPoint.zero.extent(NSSize(width:Self.kRowHeight,height:Self.kRowHeight))
        self.titlePane.frame = NSPoint(x:Self.kRowHeight,y:-self.textAlignmentInCell(self.titlePane.stringValue)).extent(NSSize(width:self.bounds.size.width - Self.kRowHeight,height:Self.kRowHeight))
        }
    }
