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
    private let iconPane = Framer(NSImageView(frame:.zero),inFrame:.square(24))
    private let titlePane = Framer(NSTextField(frame:.zero),inFrame:.remainder(from:24,0))
    
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
        iconPane.contentView?.image = NSImage(named:"IconFile64")!.resized(to: NSSize(width:24,height:24))
        titlePane.contentView?.font = StylePalette.kDefaultFont
        titlePane.contentView?.textColor = StylePalette.kPrimaryTextColor
        titlePane.contentView?.isBezeled = false
        titlePane.contentView?.drawsBackground = false
        titlePane.contentView?.stringValue = fileItem.title
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
        self.iconPane.layout(inView:self)
        self.titlePane.layout(inView:self)
        }
        
    public override func layout()
        {
        super.layout()
        self.frame = self.bounds
        self.iconPane.layout(inView:self)
        self.titlePane.layout(inView:self)
        }
    }
