//
//  PaneHand.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public class DragHand:CompositePane
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
        return(CGSize(width:150,height:150))
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
        self.path = NSBezierPath(ovalIn: self.bounds).cgPath
        self.lineWidth = 2
        self.strokeColor = NSColor.argonNeonOrange.cgColor
        self.fillColor = NSColor.clear.cgColor
        self.lineDashPattern = [2,2,2]
        for kid in self.kids
            {
            kid.bounds = NSRect(origin: .zero,size: kid.measure())
            kid.layout()
            }
        }
    }
