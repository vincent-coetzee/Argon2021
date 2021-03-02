//
//  RowView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/02.
//

import Cocoa

public class RowView:NSTableRowView
    {
    public override func drawSelection(in dirtyRect: NSRect)
        {
        if self.selectionHighlightStyle != .none
            {
            let selectionRect = self.bounds
            StylePalette.kSelectionColor.setFill()
            let selectionPath = NSBezierPath.init(roundedRect: selectionRect, xRadius: 0, yRadius: 0)
            selectionPath.fill()
            }
        }
    }
