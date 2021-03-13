//
//  CGSize+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Foundation

extension CGSize
    {
    public static func +=(lhs:inout NSSize,rhs:NSSize)
        {
        lhs.width += rhs.width
        lhs.height += rhs.height
        }
        
    public static let defaultPaneSize = CGSize(width:50,height:50)
    
    public func rectOfSize(centeredOn point:NSPoint) -> NSRect
        {
        let deltaX = self.width / 2
        let deltaY = self.height / 2
        return(NSRect(x: point.x - deltaX,y:point.y + deltaY,width:self.width,height: self.height))
        }
        
    public func expandedBy(_ amount:CGFloat) -> CGSize
        {
        return(CGSize(width: self.width + 2 * amount,height: self.height + 2 * amount))
        }
    }
