//
//  ArgonCompositeView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/05.
//

import Cocoa

public class ArgonCompositeView:NSView
    {
    private var layers:[ArgonMorph] = []
    private var mouseWasDown = false
    private var mouseDownLocation = NSPoint.zero
    
    public override var isFlipped:Bool
        {
        return(true)
        }
        
    override init(frame:NSRect)
        {
        super.init(frame:frame)
        self.wantsLayer = true
        self.layer?.isGeometryFlipped = true
        }
    
    required init?(coder: NSCoder)
        {
        super.init(coder:coder)
        self.wantsLayer = true
        self.layer?.isGeometryFlipped = true
        }
    
    public func addLayer(_ layer:ArgonMorph)
        {
        self.layer?.addSublayer(layer)
        self.layer?.setNeedsLayout()
        self.layers.append(layer)
        self.needsLayout = true
        }
        
    public override func layout()
        {
        super.layout()
        let frame = self.bounds
        for layer in self.layers
            {
            layer.layout(inFrame:frame)
            }
        }
        
    public override func mouseDown(with event: NSEvent)
        {
        self.mouseWasDown = true
        self.mouseDownLocation = self.convert(event.locationInWindow,from:nil)
        }
        
    public override func mouseUp(with event: NSEvent)
        {
        guard self.mouseWasDown else
            {
            return
            }
        self.mouseWasDown = false
        for layer in self.layers
            {
            if layer.containsLocation(self.mouseDownLocation)
                {
                layer.respondToMouseClick(at:self.mouseDownLocation,in:self)
                return
                }
            }
        }
    }
