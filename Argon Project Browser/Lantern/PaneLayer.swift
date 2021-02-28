//
//  FolioLayer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

class PaneLayer: CALayer
    {
    private let paneLayer = CALayer()
    private let arrowLayer = CALayer()
    private let dragLayer = CALayer()
    private var panes = Panes()
    public var hand = DragHand()
    private var theLayer = CALayer()
    public override init(layer:Any)
        {
        super.init(layer:layer)
        self.removeAllAnimations()
        }
        
    public override init()
        {
        super.init()
        self.paneLayer.backgroundColor = StylePalette.kDefaultBackgroundColor.cgColor
        self.addSublayer(self.paneLayer)
        self.addSublayer(self.arrowLayer)
        self.addSublayer(self.dragLayer)
        self.dragLayer.addSublayer(self.hand)
        self.hand.frame = NSRect(origin:NSPoint(x:0,y:0),size:self.hand.measure())
        self.dragLayer.setNeedsLayout()
        self.hand.layout()
        self.removeAllAnimations()
        self.theLayer.frame = NSRect(x:100,y:100,width: 100,height:100)
        self.theLayer.backgroundColor = NSColor.red.cgColor
//        self.dragLayer.addSublayer(self.theLayer)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addPane(_ pane:Pane)
        {
        self.panes += pane
        self.paneLayer.addSublayer(pane)
        pane.bounds = NSPoint.zero.extent(pane.measure())
        self.paneLayer.setNeedsLayout()
        self.paneLayer.setNeedsDisplay()
        }
        
    public func dragTo(_ point:NSPoint)
        {
        self.dragLayer.position = point
        }
        
    public func moveTo(_ point:NSPoint)
        {
        self.dragLayer.position = point
        }
        
    public func layout()
        {
        for pane in self.panes
            {
            let origin = pane.frame.origin
            pane.frame = NSRect(origin:origin,size:pane.measure())
            pane.layout()
            }
        self.hand.layout()
        }
        
    public override func layoutSublayers()
        {
        super.layoutSublayers()
        let theBounds = self.bounds
        self.paneLayer.frame = theBounds
        self.arrowLayer.frame = theBounds
        self.dragLayer.frame = theBounds
        self.hand.position = self.dragLayer.bounds.center
        self.theLayer.position = self.dragLayer.bounds.center
        self.layout()
        }
        
    public func paneUnder(point:NSPoint) -> Pane?
        {
        for pane in self.panes
            {
            if pane.frame.contains(point)
                {
                return(pane)
                }
            }
        return(nil)
        }
    }

