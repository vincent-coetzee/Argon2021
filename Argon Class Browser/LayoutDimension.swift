//
//  LayoutDimension.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/06.
//

import Foundation

extension NSRect
    {
    init(_ rectangle:Rectangle)
        {
        self.init()
        self.origin.x = CGFloat(rectangle.left)
        self.origin.y = CGFloat(rectangle.top)
        self.size.width = CGFloat(rectangle.right - rectangle.left)
        self.size.height = CGFloat(rectangle.bottom - rectangle.top)
        }
    }
    
public struct Rectangle
    {
    var left:Int
    var top:Int
    var right:Int
    var bottom:Int
    
    init(_ rect:NSRect)
        {
        self.left = Int(rect.origin.x)
        self.top = Int(rect.origin.y)
        self.right = Int(rect.origin.x + rect.size.width)
        self.bottom = Int(rect.origin.y + rect.size.height)
        }
        
    var width:Int
        {
        return(self.right - self.left)
        }
        
    var height:Int
        {
        return(self.bottom - self.top)
        }
    }
    
public class LayoutDimension
    {
    internal let modifier:LayoutModifier

    init(modifier:LayoutModifier)
        {
        self.modifier = modifier
        }
        
    public static func width(_ modifier:LayoutModifier) -> LayoutDimension
        {
        return(WidthLayoutDimension(modifier:modifier))
        }
        
    public static func height(_ modifier:LayoutModifier) -> LayoutDimension
        {
        return(HeightLayoutDimension(modifier:modifier))
        }
        
    public static func left(_ modifier:LayoutModifier) -> LayoutDimension
        {
        return(LeftLayoutDimension(modifier:modifier))
        }
        
    public static func top(_ modifier:LayoutModifier) -> LayoutDimension
        {
        return(TopLayoutDimension(modifier:modifier))
        }
        
    public static func bottom(_ modifier:LayoutModifier) -> LayoutDimension
        {
        return(BottomLayoutDimension(modifier:modifier))
        }
        
    public static func right(_ modifier:LayoutModifier) -> LayoutDimension
        {
        return(RightLayoutDimension(modifier:modifier))
        }
        
    func modify(rectangle:Rectangle) -> Rectangle
        {
        fatalError("This should have been overridden")
        }

    }
        
public class WidthLayoutDimension:LayoutDimension
    {
    override func modify(rectangle:Rectangle) -> Rectangle
        {
        let output = self.modifier.modify(self,rectangle)
        return(output)
        }
    }
    
public class HeightLayoutDimension:LayoutDimension
    {
    override func modify(rectangle:Rectangle) -> Rectangle
        {
        let output = self.modifier.modify(self,rectangle)
        return(output)
        }
    }
    
public class LeftLayoutDimension:LayoutDimension
    {
    override func modify(rectangle:Rectangle) -> Rectangle
        {
        let output = self.modifier.modify(self,rectangle)
        return(output)
        }
    }
    
public class RightLayoutDimension:LayoutDimension
    {
    override func modify(rectangle:Rectangle) -> Rectangle
        {
        let output = self.modifier.modify(self,rectangle)
        return(output)
        }
    }
    
public class TopLayoutDimension:LayoutDimension
    {
    override func modify(rectangle:Rectangle) -> Rectangle
        {
        let output = self.modifier.modify(self,rectangle)
        return(output)
        }
    }
    
public class BottomLayoutDimension:LayoutDimension
    {
    override func modify(rectangle:Rectangle) -> Rectangle
        {
        let output = self.modifier.modify(self,rectangle)
        return(output)
        }
    }
