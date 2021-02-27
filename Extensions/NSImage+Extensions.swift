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
    }
