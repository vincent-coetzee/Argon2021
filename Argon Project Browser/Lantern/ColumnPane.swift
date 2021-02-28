//
//  ColumnPane.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/28.
//

import Cocoa

public class ColumnPane:CompositePane
    {
    public override func measure() -> CGSize
        {
        var rect:NSRect = .zero
        for kid in self.kids
            {
            rect = rect.mergedColumn(kid.measure())
            }
        let spacerSize = (CGFloat(self.kids.count) - 1)*StylePalette.kColumnSpacerWidth
        return(CGSize(width:rect.width,height:rect.height + spacerSize))
        }
        
    public override func layout()
        {
        var origin = self.bounds.origin
        for kid in self.kids
            {
            let size = kid.measure()
            kid.frame = NSRect(origin: origin,size:size)
            origin.x += size.width + StylePalette.kColumnSpacerWidth
            }
        }
    }
