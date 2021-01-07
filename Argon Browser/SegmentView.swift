//
//  SegmentView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/03.
//

import Foundation
import AppKit

public class SegmentView:NSTableCellView
    {
    let title:String
    let icon:NSImage
    
    override init(frame:NSRect)
        {
        self.title = ""
        self.icon = NSImage()
        super.init(frame:frame)
        }
        
    init(title:String,icon:NSImage)
        {
        self.title = title
        self.icon = icon
        super.init(frame:.zero)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ dirtyRect: NSRect)
        {
        let font = NSFont.systemFont(ofSize: 14)
        let string = NSAttributedString(string:self.title,attributes: [.font:font,.foregroundColor:NSColor.white])
        let size = string.size()
        let imageSize = NSSize(width:32,height:32)
        let rect = NSRect(x:20+imageSize.width,y:12,width: size.width,height:size.height)
        string.draw(in: rect)
        self.icon.draw(in: NSRect(x:0,y:4,width:imageSize.width,height:imageSize.height))
        }
    }
