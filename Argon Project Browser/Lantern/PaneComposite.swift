//
//  PaneComposite.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public class PaneComposite:Pane
    {
        
    internal var kids = Panes()
    
    public convenience init(icon:NSImage,title:String)
        {
        self.init()
        self.kids += PaneText(text:title).layoutFrame(left:0,0,top:0,0,right:0,24,bottom:0,24)
        self.kids += PaneIcon(icon:icon).restLayoutAfter(24,0)
        self.layout()
        self.setNeedsDisplay()
        }
        
    public func addKid(_ kid:Pane)
        {
        self.kids += kid
        self.addSublayer(kid)
        kid.parentPane = self
        self.layout()
        }
        
    public override func layout()
        {
        let bounds = self.bounds.insetBy(dx:StylePalette.kPaneBorderWidth,dy:StylePalette.kPaneBorderWidth)
        for kid in self.kids
            {
            kid.frame = kid.layoutFrame.frame(in:bounds)
            }
        }
    }

public class PaneRowComposite:PaneComposite
    {
    public override func measure() -> CGSize
        {
        var rect:NSRect = .zero
        for kid in self.kids
            {
            rect = rect.mergedRow(kid.measure())
            }
        let spacerSize = (CGFloat(self.kids.count) - 1)*StylePalette.kRowSpacerWidth
        return(CGSize(width:rect.width + spacerSize,height:rect.height).expandedBy(StylePalette.kPaneBorderWidth))
        }
        
    public override func layout()
        {
        super.layout()
        var origin = self.bounds.insetBy(StylePalette.kPaneBorderWidth).origin
        for kid in self.kids
            {
            let size = kid.measure()
            kid.frame = NSRect(origin: origin,size:size)
            origin.x += size.width + StylePalette.kRowSpacerWidth
            }
        }
    }

public class PaneColumnComposite:PaneComposite
    {
    public override func measure() -> CGSize
        {
        var rect:NSRect = .zero
        for kid in self.kids
            {
            rect = rect.mergedColumn(kid.measure())
            }
        let spacerSize = (CGFloat(self.kids.count) - 1)*StylePalette.kColumnSpacerWidth
        return(CGSize(width:rect.width,height:rect.height + spacerSize).expandedBy(StylePalette.kPaneBorderWidth))
        }
        
    public override func layout()
        {
        super.layout()
        var origin = self.bounds.insetBy(StylePalette.kPaneBorderWidth).origin
        for kid in self.kids
            {
            let size = kid.measure()
            kid.frame = NSRect(origin: origin,size:size)
            origin.y += size.height + StylePalette.kColumnSpacerWidth
            }
        }
    }
