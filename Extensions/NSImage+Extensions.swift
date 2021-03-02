//
//  NSImage+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Cocoa

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
        
    public func coloredWith(color:NSColor) -> NSImage
        {
        var rect = NSPoint.zero.extent(self.size)
        let finalImage = CIImage(cgImage:self.cgImage(forProposedRect:&rect,context:nil,hints:nil)!).replace(color:NSColor.green,with:color)!
        let rep: NSCIImageRep = NSCIImageRep(ciImage: finalImage)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return(nsImage)
        }
    }

extension CIImage
    {
    public static func findHue(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat
        {
        let color = NSColor(red: red, green: green, blue: blue, alpha: 1)
        var hue: CGFloat = 0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
        }
        
    public static func chromaKeyFilter(fromHue: CGFloat, toHue: CGFloat) -> CIFilter?
        {
        // 1
        let size = 64
        var cubeRGB = [Float]()

        // 2
        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size-1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size-1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size-1)

                    // 3
                    let hue = self.findHue(red: red, green: green, blue: blue)
                    let alpha: CGFloat = (hue >= fromHue && hue <= toHue) ? 0: 1

                    // 4
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }
        let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))

        // 5
        let colorCubeFilter = CIFilter(name: "CIColorCube", parameters: ["inputCubeDimension": size, "inputCubeData": data])
        return colorCubeFilter
        }
        
    func filterPixels(fromRange:CGFloat,toRange:CGFloat) -> CIImage
        {
        // Remove Green from the Source Image
        let chromaCIFilter = Self.chromaKeyFilter(fromHue: fromRange, toHue: toRange)
        chromaCIFilter?.setValue(self,forKey: kCIInputImageKey)
        let sourceCIImageWithoutBackground = chromaCIFilter?.outputImage
        var image = CIImage()
        if let filteredImage = sourceCIImageWithoutBackground
            {
            image = filteredImage
            }
        return image
        }
        
    func compositeImageOver(_ image:CIImage) -> CIImage
        {
        let compositor = CIFilter(name:"CISourceOverCompositing")
        compositor?.setValue(image, forKey: kCIInputImageKey)
        compositor?.setValue(self, forKey: kCIInputBackgroundImageKey)
        let compositedCIImage = compositor?.outputImage
        var image = CIImage()
        if let compositeImage = compositedCIImage
            {
            image = compositeImage
            }
        return image
        }
        
    struct EFUIntPixel
        {
        var red: UInt8 = 0
        var green: UInt8 = 0
        var blue: UInt8 = 0
        var alpha: UInt8 = 0
        }

    func replace(color oldColor:NSColor,with newColor:NSColor) -> CIImage?
        {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
    
        let cubeSize = 64
        let cubeData = { () -> [Float] in
            oldColor.getRed(&red,green:&green,blue:&blue,alpha:&alpha)
            let selectColor = (Float(red), Float(green), Float(blue), Float(alpha))
            newColor.getRed(&red,green:&green,blue:&blue,alpha:&alpha)
            let replaceColor = (Float(red), Float(green), Float(blue), Float(alpha))

            var data = [Float](repeating: 0, count: cubeSize * cubeSize * cubeSize * 4)
            var tempRGB: [Float] = [0, 0, 0]
            var newRGB: (r : Float, g : Float, b : Float, a: Float)
            var offset = 0
            for z in 0 ..< cubeSize {
                tempRGB[2] = Float(z) / Float(cubeSize - 1) // blue value
                for y in 0 ..< cubeSize {
                    tempRGB[1] = Float(y) / Float(cubeSize -  1) // green value
                    for x in 0 ..< cubeSize {
                        tempRGB[0] = Float(x) / Float(cubeSize - 1) // red value
                        // Select colorOld
                        if tempRGB[0] == selectColor.0 && tempRGB[1] == selectColor.1 && tempRGB[2] == selectColor.2
                            {
                            newRGB = (replaceColor.0, replaceColor.1, replaceColor.2, replaceColor.3)
                            }
                        else
                            {
                            newRGB = (tempRGB[0], tempRGB[1], tempRGB[2], 1)
                            }
                        data[offset] = newRGB.r
                        data[offset + 1] = newRGB.g
                        data[offset + 2] = newRGB.b
                        data[offset + 3] = 1.0
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
