//
//  PaneText.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

extension NSRect
    {
    public static func +=(lhs:inout NSRect,rhs:NSPoint)
        {
        lhs.origin.x = lhs.origin.x + rhs.x
        lhs.origin.y = lhs.origin.y + rhs.y
        }
    }
    
public class PaneText:Pane
    {
    private let actualText = CATextLayer()
    private var textSize:CGSize = .zero
    
    public var font:NSFont = StylePalette.kDefaultFont
        {
        didSet
            {
            self.fontName = font.fontName
            self.fontSize = font.pointSize
            self.textSize = self.measureText()
            }
        }
        
    public var fontName:String
        {
        get
            {
            return((self.actualText.font as! NSFont).fontName)
            }
        set
            {
            self.actualText.font = newValue as CFTypeRef
            self.textSize = self.measureText()
            }
        }
        
    public var text:String?
        {
        get
            {
            return(self.actualText.string as? String)
            }
        set
            {
            self.actualText.string = newValue
            self.textSize = self.measureText()
            }
        }
        
    public var fontSize:CGFloat
        {
        get
            {
            return((self.actualText.fontSize))
            }
        set
            {
            self.actualText.fontSize = newValue
            self.textSize = self.measureText()
            }
        }
        
    public var textColor:NSColor
        {
        get
            {
            return(NSColor(cgColor:self.actualText.foregroundColor ?? CGColor.black) ?? NSColor.black)
            }
        set
            {
            self.actualText.foregroundColor = newValue.cgColor
            self.textSize = self.measureText()
            }
        }
        
    public convenience init(text:String,font:NSFont = StylePalette.kDefaultFont,color:NSColor = StylePalette.kPrimaryTextColor)
        {
        self.init()
        self.addSublayer(self.actualText)
        self.actualText.string = text
        self.actualText.font = font
        self.actualText.fontSize = font.pointSize
        self.actualText.foregroundColor = color.cgColor
        self.layout()
        self.setNeedsDisplay()
        }
        
    private func measureText() -> CGSize
        {
        let attributedString = NSAttributedString(string:self.text ?? "",attributes:[.font:font,.foregroundColor:self.actualText.foregroundColor])
        let size = attributedString.size()
        print("TEXT SIZE = \(size)")
        return(size)
        }
    
    internal override func measure() -> CGSize
        {
        let size = self.measureText().expandedBy(StylePalette.kPaneBorderWidth)
        print("MEASURE SIZE = \(size)")
        return(size)
        }
        
    public override func layout()
        {
        print("PANE-TEXT LAYOUT")
        print("PANE-TEXT BOUNDS = \(self.bounds)")
        var textFrame = NSRect(origin:.zero,size:self.textSize)
        print("PANE-TEXT TEXT-RECT = \(textFrame)")
        textFrame = textFrame.centeredIn(self.bounds)
        print("CENTERED FRAME = \(textFrame)")
        textFrame += NSPoint(x:0,y:2)
        self.actualText.frame = textFrame
        }
        
    public override func layoutSublayers()
        {
        super.layoutSublayers()
        self.layout()
        }
    }
