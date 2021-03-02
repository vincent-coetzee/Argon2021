//
//  ArgonProjectOutlineView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/24.
//

import Cocoa

class ArgonProjectOutlineView: NSOutlineView
    {
    private var currentImageView:NSImageView?
    private var trackingArea:NSTrackingArea?
    
    override func menu(for event: NSEvent) -> NSMenu?
        {
        let point = self.convert(event.locationInWindow, from: nil)
        let row = self.row(at: point)
        let item = self.item(atRow: row)
        let view = self.view(atColumn: 0, row: row, makeIfNecessary: false)
        if (item == nil)
            {
            return nil
            }
        return((view as! ItemBrowserCell).menu(for:event,in:row,on:item as! Elemental))
        }
    }
