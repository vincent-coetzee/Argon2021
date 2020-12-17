//
//  DisplayView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/08.
//

import Cocoa

@IBDesignable
class DisplayView: NSView
    {
    private var textLayer:CATextLayer?
    
    override init(frame:NSRect)
        {
        super.init(frame:frame)
        self.initCommon()
        }
    
    private func initCommon()
        {
        if self.textLayer == nil
            {
            self.textLayer = CATextLayer()
            self.wantsLayer = true
            self.layer?.addSublayer(textLayer!)
            self.layer?.backgroundColor = NSColor.white.cgColor
            }
        self.textLayer?.string = "Display"
        self.textLayer?.foregroundColor = .white
        self.textLayer?.frame = self.bounds
        }
        
    required init?(coder: NSCoder)
        {
        super.init(coder: coder)
        self.initCommon()
        }
        
    override func prepareForInterfaceBuilder()
        {
        super.prepareForInterfaceBuilder()
        self.initCommon()
        }
    }
