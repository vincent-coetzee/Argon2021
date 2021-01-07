//
//  ArgonBrowserLayer.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/01/05.
//

import Cocoa

public class ArgonMorph:CALayer
    {
    public static let kLineWidth:CGFloat = 2
    public static let kCornerRadius:CGFloat = 10
    public static let kLineColor = NSColor(red:255,green:166,blue:0).cgColor
    public static let kBackgroundColor = NSColor.black.cgColor
    public static let kTextColor = NSColor.white.cgColor
    public static let kFontName = "Poppins Bold"
    public static let kSourceFontName = "Menlo"
    public static let kLargeFontSize:CGFloat = 18.0
    public static let kMediumFontSize:CGFloat = 15.0
    public static let kStandardFontSize:CGFloat = 16.0
    public static let kSourceFontSize:CGFloat = 11.0
    public static let kLargeFont = NSFont(name:ArgonMorph.kFontName,size:ArgonMorph.kLargeFontSize)!
    public static let kMediumFont = NSFont(name:ArgonMorph.kFontName,size:ArgonMorph.kMediumFontSize)!
    public static let kStandardFont = NSFont(name:ArgonMorph.kFontName,size:ArgonMorph.kStandardFontSize)!
    public static let kSourceFont = NSFont(name:ArgonMorph.kSourceFontName,size:ArgonMorph.kSourceFontSize)!

    var layoutFrame:LayoutFrame = .zero
    
    var markAsNeedingLayout:Bool
        {
        get
            {
            return(true)
            }
        set
            {
            if newValue == true
                {
                self.setNeedsLayout()
                }
            }
        }
        
    var markAsNeedingDisplay:Bool
        {
        get
            {
            return(true)
            }
        set
            {
            if newValue == true
                {
                self.setNeedsDisplay()
                }
            }
        }
        
    var estimatedSize:NSSize
        {
        return(.zero)
        }
        
    override init(layer:Any)
        {
        super.init(layer:layer)
        }
        
    override init()
        {
        super.init()
        self.borderWidth = Self.kLineWidth
        self.borderColor = Self.kLineColor
        self.backgroundColor = Self.kBackgroundColor
        self.cornerRadius = Self.kCornerRadius
        }
    
    required init?(coder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
        
    func resetAttributes()
        {
        self.borderWidth = 0
        self.borderColor = nil
        self.backgroundColor = nil
        self.cornerRadius = 0
        self.contents = nil
        }
        
    func layout(inFrame aRect:NSRect)
        {
        let rectangle = self.layoutFrame.rectangle(in:aRect)
        self.frame = rectangle
        }
        
    func containsLocation(_ point:NSPoint) -> Bool
        {
        return(self.frame.contains(point))
        }
        
    func respondToMouseClick(at:NSPoint,in:ArgonCompositeView)
        {
        }
    }

