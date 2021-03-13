//
//  NSImage+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Cocoa

private var cache:[NSImage:NSImage] = [:]

extension NSImage
    {
    public func resized(to newSize:NSSize) -> NSImage
        {
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        self.size = newSize
        NSGraphicsContext.current?.imageInterpolation = .high
        self.draw(in: NSRect(origin: .zero, size: newSize))
        newImage.unlockFocus()
        return(newImage)
        }
        
    func fillWith(color:NSColor)
        {
        self.lockFocus()
        color.setFill()
        let rect = NSPoint.zero.extent(self.size)
        NSBezierPath(rect: rect).fill()
        self.unlockFocus()
        }
        
    public func tintedWith(_ color:NSColor) -> NSImage
        {
        self.isTemplate = true
        let image = self.copy() as! NSImage
        image.lockFocus()
        color.set()
        let imageRect = NSRect(origin:.zero,size:self.size)
        imageRect.fill(using: .sourceIn)
		image.unlockFocus()
        image.isTemplate = false
        return(image)
        }
        
    public func coloredWith(color:NSColor) -> NSImage
        {
        if let image = cache[self]
            {
            return(image)
            }
        var rect = NSPoint.zero.extent(self.size)
        let finalImage = CIImage(cgImage:self.cgImage(forProposedRect:&rect,context:nil,hints:nil)!).replace(fromHue:0.3,toHue:0.4,with:color)!
        let cgImage = self.ciImageToCGImage(finalImage)!
        let image = NSImage(cgImage:cgImage,size:rect.size)
        cache[self] = image
        return(image)
//        let rep: NSCIImageRep = NSCIImageRep(ciImage: finalImage)
//        let nsImage: NSImage = NSImage(size: rep.size)
//        nsImage.addRepresentation(rep)
//        return(nsImage)
        }
        
    func ciImageToCGImage(_ inputImage: CIImage) -> CGImage?
        {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent)
            {
            return cgImage
            }
        return nil
        }
    }

extension CIImage
    {
    func localHue(red: Float, green: Float, blue: Float) -> CGFloat
        {
        let color = NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        var hue: CGFloat = 0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
        }

    func replace(fromHue:CGFloat,toHue:CGFloat,with newColor:NSColor) -> CIImage?
        {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
    
        let cubeSize = 64
        let cubeData = { () -> [Float] in
            newColor.getRed(&red,green:&green,blue:&blue,alpha:&alpha)
            let replaceColor = (Float(red), Float(green), Float(blue), Float(alpha))

            var data = [Float](repeating: 0, count: cubeSize * cubeSize * cubeSize * 4)
            var offset = 0
            for z in 0 ..< cubeSize {
                let blue = Float(z) / Float(cubeSize - 1) // blue value
                for y in 0 ..< cubeSize {
                    let green = Float(y) / Float(cubeSize -  1) // green value
                    for x in 0 ..< cubeSize {
                        let red = Float(x) / Float(cubeSize - 1) // red value
                        let theHue = self.localHue(red:red,green:green,blue:blue)
                        
                        let alpha:Float = (theHue >= fromHue && theHue <= toHue) == true ? 1.0 : 0.0
                        data[offset] = alpha > 0.0 ? replaceColor.0 * alpha : Float(0)
                        data[offset + 1] = alpha > 0.0 ? replaceColor.1 * alpha : Float(0)
                        data[offset + 2] = alpha > 0.0 ? replaceColor.2 * alpha : Float(0)
                        data[offset + 3] = alpha
                        offset += 4
                    }
                }
            }
            return data
        }()

        let data = cubeData.withUnsafeBufferPointer { Data(buffer: $0) } as NSData
        let colorCube = CIFilter(name: "CIColorCube")!
        colorCube.setValue(cubeSize, forKey: "inputCubeDimension")
        colorCube.setValue(data, forKey: "inputCubeData")
        colorCube.setValue(self, forKey: kCIInputImageKey)
        return colorCube.outputImage
        }
    }
