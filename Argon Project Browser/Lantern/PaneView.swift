//
//  PaneView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

class PaneView: NSView
    {
    private let paneLayer = PaneLayer()
    private var isDragging = false
    private var mouseIsDown = false
    private var hand = PaneHand()
    private var handOffset:NSPoint = .zero
    private var trackingArea:NSTrackingArea?
    
    override init(frame:NSRect)
        {
        super.init(frame:frame)
        self.wantsLayer = true
        self.layer?.addSublayer(self.paneLayer)
        self.paneLayer.frame = self.layer!.bounds
        self.hand = self.paneLayer.hand
        self.paneLayer.addSublayer(hand)
        self.paneLayer.drawsAsynchronously = true
        self.paneLayer.removeAllAnimations()
        self.trackingArea = NSTrackingArea(rect: self.frame, options: [.mouseEnteredAndExited,.activeAlways,.inVisibleRect,.mouseMoved],owner: self, userInfo: nil)
        self.addTrackingArea(self.trackingArea!)
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addPane(_ pane:Pane)
        {
        self.paneLayer.addPane(pane)
        }
        
    public override func layout()
        {
        super.layout()
        self.paneLayer.frame = self.bounds
        self.paneLayer.layout()
        self.paneLayer.setNeedsLayout()
        self.paneLayer.setNeedsDisplay()
        }
        
    public override func mouseDown(with event:NSEvent)
        {
        self.mouseIsDown = true
        let localPoint = self.convert(event.locationInWindow,from:nil)
        self.hand.movePositionTo(localPoint)
        if let pane = self.paneLayer.paneUnder(point:localPoint)
            {
            pane.removeFromSuperlayer()
            self.hand.addKid(pane)
            self.hand.layout()
            }
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        self.paneLayer.displayIfNeeded()
        CATransaction.commit()
        }
        
    public func initDemoPanes()
        {
        self.initDemoTextPanes()
        }
        
    private func initDemoTextPanes()
        {
        var pane = PaneText(text:"Hello World")
        pane.frame = NSRect(origin:NSPoint(x:300,y:300),size: pane.measure())
        pane.font = StylePalette.kDefaultFont
        pane.textColor = StylePalette.kPrimaryTextColor
        self.addPane(pane)
        pane = PaneText(text:"This is a rather long piece of text\nthat will serve as a demonstration of how panes handle\nallsorts of text.\nThe quick brown fox jumped over the lazy dog\nwhich was fast asleep on the couch.")
        pane.frame = NSRect(origin:NSPoint(x:40,y:700),size: pane.measure())
        pane.font = StylePalette.kHeadlineFont
        pane.textColor = StylePalette.kHeadlineTextColor
        self.addPane(pane)
        }
        
//    public override func mouseDragged(with event:NSEvent)
//        {
//        let localPoint = self.convert(event.locationInWindow,from:nil)
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        self.hand.movePositionTo(localPoint)
//        self.paneLayer.displayIfNeeded()
//        CATransaction.commit()
//        }
        
    public override func mouseUp(with event:NSEvent)
        {
        self.mouseIsDown = false
        let localPoint = self.convert(event.locationInWindow,from:nil)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.hand.movePositionTo(localPoint)
        self.paneLayer.displayIfNeeded()
        CATransaction.commit()
        }
        
    public override func mouseMoved(with event:NSEvent)
        {
        self.mouseIsDown = false
        let localPoint = self.convert(event.locationInWindow,from:nil)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.hand.movePositionTo(localPoint)
        self.paneLayer.displayIfNeeded()
        CATransaction.commit()
        }
        
    public override func mouseEntered(with event:NSEvent)
        {
        let localPoint = self.convert(event.locationInWindow,from:nil)
        self.hand.movePositionTo(localPoint)
        }
    }
