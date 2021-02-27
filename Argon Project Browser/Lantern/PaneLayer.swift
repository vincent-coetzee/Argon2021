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
    public var hand = PaneHand()
    
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
        self.hand.frame = NSRect(origin:.zero,size:self.hand.measure())
        self.hand.layout()
        self.addSublayer(hand)
        self.removeAllAnimations()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addPane(_ pane:Pane)
        {
        self.panes += pane
        self.paneLayer.addSublayer(pane)
        self.paneLayer.setNeedsLayout()
        self.paneLayer.setNeedsDisplay()
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

