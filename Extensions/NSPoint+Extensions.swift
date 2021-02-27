//
//  NSPoint+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/27.
//

import Foundation

extension NSPoint
    {
    public static func -(lhs:NSPoint,rhs:NSPoint) -> NSPoint
        {
        return(NSPoint(x: lhs.x - rhs.x,y: lhs.y - rhs.y))
        }
    }
