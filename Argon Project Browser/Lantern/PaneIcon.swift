//
//  PaneIcon.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa
import CoreImage

public class PaneIcon:Pane
    {
    private var imageSize:CGSize = .zero
    
    public convenience init(icon:NSImage)
        {
        self.init()
        self.imageSize = icon.size
        self.contents = icon.cgImage
        self.contentsGravity = .resizeAspectFill
        self.layout()
        self.setNeedsDisplay()
        }
        
    internal override func measure() -> CGSize
        {
        return(self.imageSize.expandedBy(StylePalette.kPaneBorderWidth))
        }
    }
