//
//  NSRect+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Foundation

extension NSRect
    {
    public static let zero = NSRect(x:0,y:0,width:0,height:0)
    
    public func insetBy(_ amount:CGFloat) -> NSRect
        {
        return(self.insetBy(dx:amount,dy:amount))
        }
        
    public func expandedBy(_ delta:CGFloat) -> NSRect
        {
        var newRect = self
        newRect.size.width += 2*delta
        newRect.size.height += 2*delta
        return(newRect)
        }
        
    public func mergedRow(_ size:CGSize) -> NSRect
        {
        var newRect = self
        newRect.size.width += size.width
        newRect.size.height = max(newRect.size.height,size.height)
        return(newRect)
        }
        
    public func mergedColumn(_ size:CGSize) -> NSRect
        {
        var newRect = self
        newRect.size.width = max(newRect.size.width,size.width)
        newRect.size.height += size.height
        return(newRect)
        }
        
    public func centeredIn(_ outer:NSRect) -> NSRect
        {
        var newRect = self
        newRect.origin.x  = (outer.width - self.width)/2
        newRect.origin.y = (outer.height - self.height)/2
        return(newRect)
        }
    }
