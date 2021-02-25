//
//  DecoratorView.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/25.
//

import Cocoa

@IBDesignable
class DecoratorView: NSView
    {
    @IBInspectable
    public var borderWidth:CGFloat = 5
        {
        didSet
            {
            self.layer!.borderWidth = self.borderWidth
            }
        }
        
    @IBInspectable
    public var borderColor:NSColor = NSColor.argonNeonPink
        {
        didSet
            {
            self.layer!.borderColor = self.borderColor.cgColor
            }
        }
        
    @IBInspectable
    public var cornerRadius:CGFloat = 10
        {
        didSet
            {
            self.layer!.cornerRadius = self.cornerRadius
            }
        }
        
    override func awakeFromNib()
        {
        super.awakeFromNib()
        self.wantsLayer = true
        self.layer = CALayer()
        }
        
    init()
        {
        super.init(frame:.zero)
        self.wantsLayer = true
        self.layer = CALayer()
        }
        
    override init(frame:NSRect)
        {
        super.init(frame:frame)
        self.wantsLayer = true
        self.layer = CALayer()
        }
        
    required init(coder:NSCoder)
        {
        super.init(coder:coder)!
        self.wantsLayer = true
        self.layer = CALayer()
        }
        
    public override func prepareForInterfaceBuilder()
        {
        super.prepareForInterfaceBuilder()
        self.wantsLayer = true
        self.layer = CALayer()
        }
    }
