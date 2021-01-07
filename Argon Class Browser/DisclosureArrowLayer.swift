//
//  DisclosureArrowLayer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/06.
//

import Cocoa

extension NSRect
    {
    var center:NSPoint
        {
        return(NSPoint(x:self.midX,y:self.midY))
        }
    }
    
public typealias DisclosureAction = (DisclosureArrowLayer) -> Void

public class DisclosureArrowLayer:ArgonMorph
    {
    private var isDisclosed = false
    private var arrowLayer = CALayer()
    private let disclosedAngle:CGFloat = 0
    private let nonDisclosedAngle:CGFloat = 3 * CGFloat.pi / 2
    public var action:DisclosureAction = { layer in }
    
    override init()
        {
        super.init()
        self.borderWidth = 0
        self.borderColor = nil
        self.backgroundColor = ArgonMorph.kLineColor
        self.cornerRadius = 8
        self.contents = NSImage(named:"DisclosureArrowIcon")!
        self.contentsGravity = .resizeAspectFill
        self.transform = CATransform3DMakeRotation(nonDisclosedAngle, 0, 0,1)
        }
        
    override init(layer:Any)
        {
        self.action = { layer in }
        super.init(layer:layer)
        }
        
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }

    override func respondToMouseClick(at:NSPoint,in:ArgonCompositeView)
        {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        let angle = self.isDisclosed ? nonDisclosedAngle : disclosedAngle
        self.transform = CATransform3DMakeRotation(angle, 0,0,1)
        CATransaction.commit()
        self.isDisclosed = !self.isDisclosed
        }
    }
