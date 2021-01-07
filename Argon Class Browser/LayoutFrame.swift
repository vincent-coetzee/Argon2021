//
//  LayoutFrame.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/05.
//

import Foundation
    
public class LayoutFrame
    {
    public static let zero = LayoutFrame()
    
    var layoutDimensions:[LayoutDimension] = []
    
        
    @discardableResult
    func layoutDimension(_ dimension:LayoutDimension) -> LayoutFrame
        {
        self.layoutDimensions.append(dimension)
        return(self)
        }
        
    func rectangle(in rectangle:NSRect) -> NSRect
        {
        var output = Rectangle(rectangle)
        for dimension in self.layoutDimensions
            {
            output = dimension.modify(rectangle:output)
            }
        return(NSRect(output))
        }
    }
    
public enum HorizontalAlignment
    {
    case left
    case middle
    case right
    case justify
    }
    
public enum VerticalAlignment
    {
    case top
    case middle
    case bottom
    }
    
