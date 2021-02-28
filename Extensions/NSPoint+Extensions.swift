//
//  NSPoint+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/27.
//

import Foundation

extension NSPoint
    {
    public func centeredRect(ofSize size:NSSize) -> NSRect
        {
        let deltaX = size.width / 2
        let deltaY = size.height / 2
        return(NSRect(x: self.x - deltaX,y:self.y + deltaY,width:size.width,height: size.height))
        }
        
    public static func -(lhs:NSPoint,rhs:NSPoint) -> NSPoint
        {
        return(NSPoint(x: lhs.x - rhs.x,y: lhs.y - rhs.y))
        }
        
    public static func random(in rect:NSRect) -> NSPoint
        {
        let x = CGFloat.random(in: rect.origin.x..<rect.size.width + rect.origin.x)
        let y = CGFloat.random(in: rect.origin.y..<rect.size.height + rect.origin.y)
        return(NSPoint(x:x,y:y))
        }
        
    public func extent(_ size:NSSize) -> NSRect
        {
        return(NSRect(origin: self,size:size))
        }
    }
