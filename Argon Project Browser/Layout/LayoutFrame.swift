//
//  LayoutFrame.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/25.
//

import Foundation

public class LayoutFrame
    {
    public static let sizeToBounds = LayoutFrame(left:0,0,top:0,0,right: 1.0,0,bottom:1.0,0)
    public static let zero = LayoutFrame(left:0,0,top:0,0,right: 0,0,bottom:0,0)
    
    public static func square(_ value:CGFloat) -> LayoutFrame
        {
        return(LayoutFrame(left:0,0,top:0,0,right:0,value,bottom:0,value))
        }
        
    public static func remainder(from left:CGFloat,_ top:CGFloat) -> LayoutFrame
        {
        return(LayoutFrame(left:0,left,top:0,top,right:1,0,bottom:1,0))
        }
        
        
    let leftFraction:CGFloat
    let leftOffset:CGFloat
    let topFraction:CGFloat
    let topOffset:CGFloat
    let rightFraction:CGFloat
    let rightOffset:CGFloat
    let bottomFraction:CGFloat
    let bottomOffset:CGFloat
    
    init(left:CGFloat,_ leftOffset:CGFloat,top:CGFloat,_ topOffset:CGFloat,right:CGFloat,_ rightOffset:CGFloat,bottom:CGFloat,_ bottomOffset:CGFloat)
        {
        self.leftFraction = left
        self.leftOffset = leftOffset
        self.rightFraction = right
        self.rightOffset = rightOffset
        self.topFraction = top
        self.topOffset = topOffset
        self.bottomFraction = bottom
        self.bottomOffset = bottomOffset
        }

    public func frame(in frame:NSRect) -> NSRect
        {
        let left = self.leftFraction * frame.maxX + self.leftOffset + frame.minX
        let top = self.topFraction * frame.maxY + self.topOffset + frame.minY
        let right = self.rightFraction * frame.maxX + self.rightOffset + frame.minX
        let bottom = self.bottomFraction * frame.maxY + self.bottomOffset + frame.minY
        return(NSRect(x:left,y:top,width: right - left,height:bottom - top))
        }
    }

