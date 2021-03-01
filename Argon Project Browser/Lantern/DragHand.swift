//
//  PaneHand.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public class DragHand:Pane
    {
    private struct DragPassport
        {
        let pane:Pane
        let sourceLayer:CALayer
        }
        
    private var dragPane:Pane?
    private var passport:DragPassport?
    
    public override init()
        {
        super.init()
        self.removeAllAnimations()
        }
    
    public override init(layer:Any)
        {
        super.init(layer:layer)
        self.removeAllAnimations()
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func collectDragPane(_ pane:Pane,atPoint:NSPoint,inLayer:CALayer)
        {
        self.passport = DragPassport(pane:pane,sourceLayer:pane.superlayer!)

        print("HAND POSITION = \(self.position)")
        print("DRAGLAYER POSITION = \(super.superlayer!.position)")
        let dragLayer = self.superlayer!
        let delta = dragLayer.convert(pane.position,from:inLayer) - dragLayer.convert(atPoint,from:inLayer)
        print("DELTA =\(delta)")
        pane.position = self.position + delta
        pane.removeFromSuperlayer()
        dragLayer.addSublayer(pane)
        pane.layout()
        dragPane = pane
        }
        
    public func dropDragPane(atPoint:NSPoint,inLayer:CALayer)
        {
        if let pane = dragPane,let passport = self.passport
            {
            let dragLayer = self.superlayer!
            let delta = dragLayer.convert(pane.position,to:inLayer)
            pane.removeFromSuperlayer()
            passport.sourceLayer.addSublayer(pane)
            pane.position = delta
            }
        }
        
    public override func measure() -> CGSize
        {
        return(CGSize(width:150,height:150))
        }
        
    public override func layout()
        {
        self.path = NSBezierPath(ovalIn: self.bounds).cgPath
        self.lineWidth = 2
        self.strokeColor = NSColor.argonNeonOrange.cgColor
        self.fillColor = NSColor.clear.cgColor
        self.lineDashPattern = [2,2,2]
        if let pane = self.dragPane
            {
            pane.bounds = NSPoint.zero.extent(pane.measure())
            pane.layout()
            }
        }
    }
