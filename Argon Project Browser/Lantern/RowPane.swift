//
//  RowPane.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/28.
//

import Cocoa

public class RowPane:CompositePane
    {
    public override func measure() -> CGSize
        {
        var rect:NSRect = .zero
        for kid in self.kids
            {
            rect = rect.mergedRow(kid.measure())
            }
        let spacerSize = (CGFloat(self.kids.count) - 1)*StylePalette.kRowSpacerWidth
        return(CGSize(width:rect.width + spacerSize,height:rect.height))
        }
        
    public override func layout()
        {
        var origin = self.bounds.origin
        for kid in self.kids
            {
            let size = kid.measure()
            kid.frame = NSRect(origin: origin,size:size)
            origin.y += size.height + StylePalette.kRowSpacerWidth
            }
        }
    }
