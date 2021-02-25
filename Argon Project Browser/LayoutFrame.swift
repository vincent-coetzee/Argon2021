//
//  LayoutFrame.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/25.
//

import Foundation

public class LayoutFrame
    {
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
        let left = self.leftFraction * frame.minX + self.leftOffset
        let top = self.topFraction * frame.minY + self.topOffset
        let right = self.rightFraction * frame.maxX + self.rightOffset
        let bottom = self.bottomFraction * frame.maxY + self.bottomOffset
        return(NSRect(x:left,y:top,width: right - left,height:bottom - top))
        }
    }
