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
        return((view as! OutlineItemCell).menu(for:event,in:row,on:item as! OutlineItem))
        }
        
    public override func mouseEntered(with event: NSEvent)
        {
        print("mouse in")
        super.mouseEntered(with:event)
        let location = self.convert(event.locationInWindow,from:nil)
        let row = self.row(at: location)
        guard row >= 0 else
            {
            return
            }
        print("mouse passed")
        let view = self.view(atColumn: 0, row: row, makeIfNecessary: false)
        let image = NSImageView(frame:NSRect(x:0,y:0,width:24,height:24))
        image.image = NSImage(systemSymbolName:"trash.fill",accessibilityDescription:nil)
        view?.addSubview(image)
        if self.currentImageView != nil
            {
            self.currentImageView?.removeFromSuperview()
            }
        self.currentImageView = image
        }
        
    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }

        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }

    public override func mouseExited(with event: NSEvent)
        {
        print("mouse out")
        super.mouseExited(with:event)
        self.currentImageView?.removeFromSuperview()
        }
    
    public override func drawRow(_ row: Int, clipRect: NSRect)
        {
        NSColor.sizzlingRed.set()
        clipRect.fill()
        }
        
    public override func drawBackground(inClipRect clipRect:NSRect)
        {
        NSColor.sizzlingRed.set()
        clipRect.fill()
        }
        
    override func rowView(atRow row: Int,makeIfNecessary: Bool) -> NSTableRowView?
        {
        return(OutlineRowView(frame:.zero))
        }
        
    override func view(atColumn column:Int,row:Int,makeIfNecessary:Bool) -> NSTableRowView?
        {
        return(OutlineRowView(frame:.zero))
        }
        

    }

public class OutlineRowView:NSTableRowView
    {
    public override func draw(_ dirtyRect: NSRect) {
        NSColor.sizzlingRed.set()
        dirtyRect.fill()
        self.isEmphasized = false
        }
        
    public override func drawSelection(in dirtyRect:NSRect)
        {

            let selectionRect = NSInsetRect(self.bounds, 2.5, 2.5);
            NSColor.sizzlingRed.set()
            let path = NSBezierPath(roundedRect: selectionRect, xRadius: 6, yRadius: 6)
            path.fill()
            path.stroke()
            }
    }
