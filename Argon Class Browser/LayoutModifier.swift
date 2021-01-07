//
//  LayoutModifier.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/06.
//

import Foundation

public class LayoutModifier
    {
    public static func fit() -> LayoutModifier
        {
        return(FitLayoutModifier())
        }
        
    public static func absolute(_ pixels:Int) -> LayoutModifier
        {
        return(PixelsLayoutModifier(pixels:pixels))
        }
        
    public static func relative(_ pixels:Int,sourceLayer:ArgonMorph) -> LayoutModifier
        {
        return(DeltaLayoutModifier(pixels:pixels,sourceLayer:sourceLayer))
        }
        
    public static func fraction(_ fraction:CGFloat,_ offset:Int) -> LayoutModifier
        {
        return(FractionLayoutModifier(fraction:fraction,offset:offset))
        }
        
    func modify(_ dimension:LeftLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        fatalError("This should have been overriden")
        }
        
    func modify(_ dimension:RightLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        fatalError("This should have been overriden")
        }
        
    func modify(_ dimension:TopLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        fatalError("This should have been overriden")
        }
        
    func modify(_ dimension:BottomLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        fatalError("This should have been overriden")
        }
        
    func modify(_ dimension:WidthLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        fatalError("This should have been overriden")
        }
        
    func modify(_ dimension:HeightLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        fatalError("This should have been overriden")
        }
    }
    
public class FitLayoutModifier:LayoutModifier
    {
    override func modify(_ dimension:LeftLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        return(rectangle)
        }
        
    override func modify(_ dimension:RightLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        return(rectangle)
        }
        
    override func modify(_ dimension:TopLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        return(rectangle)
        }
        
    override func modify(_ dimension:BottomLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        return(rectangle)
        }
    }
    
public class PixelsLayoutModifier:LayoutModifier
    {
    let pixels:Int
    
    init(pixels:Int)
        {
        self.pixels = pixels
        super.init()
        }
        
    override func modify(_ dimension:LeftLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        output.left = self.pixels
        return(output)
        }
        
    override func modify(_ dimension:RightLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        output.right = self.pixels
        return(output)
        }
        
    override func modify(_ dimension:TopLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        output.top = self.pixels
        return(output)
        }
        
    override func modify(_ dimension:BottomLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        output.bottom = self.pixels
        return(output)
        }
    }
    
public class DeltaLayoutModifier:LayoutModifier
    {
    let pixels:Int
    let sourceLayer:ArgonMorph
    
    init(pixels:Int,sourceLayer:ArgonMorph)
        {
        self.pixels = pixels
        self.sourceLayer = sourceLayer
        super.init()
        }
        
    override func modify(_ dimension:LeftLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        let left = self.sourceLayer.frame.origin.x
        output.left = self.pixels + Int(left)
        return(output)
        }
        
    override func modify(_ dimension:RightLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        let right = Int(self.sourceLayer.frame.maxX)
        output.right = self.pixels + right
        return(output)
        }
        
    override func modify(_ dimension:TopLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        let top = Int(self.sourceLayer.frame.minY)
        output.top = self.pixels + top
        return(output)
        }
        
    override func modify(_ dimension:BottomLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        let bottom = Int(self.sourceLayer.frame.maxY)
        output.bottom = self.pixels + bottom
        return(output)
        }
    }
    
public class FractionLayoutModifier:LayoutModifier
    {
    let fraction:CGFloat
    let offset:Int
    
    init(fraction:CGFloat,offset:Int)
        {
        self.fraction = fraction
        self.offset = offset
        super.init()
        }
        
    override func modify(_ dimension:LeftLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        output.left = Int(self.fraction * CGFloat(rectangle.width)) + self.offset + rectangle.left
        return(output)
        }
        
    override func modify(_ dimension:RightLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        output.right = Int(self.fraction * CGFloat(rectangle.width)) + self.offset + rectangle.left
        return(output)
        }
        
    override func modify(_ dimension:TopLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        output.top = Int(self.fraction * CGFloat(rectangle.height)) + self.offset + rectangle.top
        return(output)
        }
        
    override func modify(_ dimension:BottomLayoutDimension,_ rectangle:Rectangle) -> Rectangle
        {
        var output = rectangle
        output.bottom = Int(self.fraction * CGFloat(rectangle.height)) + self.offset + rectangle.top
        return(output)
        }
    }
