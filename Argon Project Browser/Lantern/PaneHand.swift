//
//  PaneHand.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public class PaneHand:PaneComposite
    {
    private var handOffset:NSPoint = .zero
    
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
    
    public override func measure() -> CGSize
        {
        return(CGSize(width:75,height:75))
        }
        
    internal override func initBorderStyle()
        {
        // block parents from settting border style
        }
        
    internal override func initGrounds()
        {
        // block parents from setting foreground and background
        }
        
    public func movePositionTo(_ point:NSPoint)
        {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.handOffset = self.frame.origin - point
        self.position = point
        self.setNeedsLayout()
        self.setNeedsDisplay()
        CATransaction.commit()
        }
        
    public override func addKid(_ kid:Pane)
        {
        super.addKid(kid)
        let kidFrame = kid.frame
        let offset = kidFrame.origin - self.frame.origin
        kid.frame = NSRect(origin: offset,size:kidFrame.size)
        }
        
    public func calibrate(atPoint:NSPoint)
        {
        self.handOffset = self.frame.origin - atPoint
        }
        
    public override func layout()
        {
        print("LAYING OUT HAND IN FRAME \(self.frame)")
        super.layout()
        self.path = NSBezierPath(ovalIn: self.bounds).cgPath
        self.lineWidth = 2
        self.strokeColor = NSColor.white.cgColor
        }
    }
