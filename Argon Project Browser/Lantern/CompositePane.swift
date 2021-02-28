//
//  PaneComposite.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public class CompositePane:Pane
    {
        
    internal var kids = Panes()
    
    public convenience init(icon:NSImage,title:String)
        {
        self.init()
        self.kids += TextPane(text:title).layoutFrame(left:0,0,top:0,0,right:0,24,bottom:0,24)
        self.kids += PaneIcon(icon:icon).restLayoutAfter(24,0)
        self.layout()
        self.setNeedsDisplay()
        }
        
    public func addKid(_ kid:Pane)
        {
        self.kids += kid
        self.addSublayer(kid)
        self.layout()
        }
        
    public override func layout()
        {
        let rect = self.bounds
        for kid in self.kids
            {
            kid.frame = kid.layoutFrame.frame(in:rect)
            }
        }
    }






    
