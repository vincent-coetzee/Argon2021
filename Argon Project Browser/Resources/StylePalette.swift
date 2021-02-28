//
//  StylePalette.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa
    
public class StylePalette
    {
    public static let shared = StylePalette()
    
    private static let kBodyFontSize:CGFloat = 12
    private static let kBodyFontWeight = 5
    private static let kEmphasizedFontSize:CGFloat = 12
    private static let kEmphasizedFontWeight = 7
    private static let kTitle1FontSize:CGFloat = 18
    private static let kTitle2FontSize:CGFloat = 16
    private static let kTitle1FontWeight = 12
    private static let kTitle2FontWeight = 10
    private static let kCaptionFontSize:CGFloat = 12
    private static let kCalloutFontSize:CGFloat = 14
    private static let kCaptionFontWeight = 6
    private static let kCalloutFontWeight = 7
    
    public static let kDefaultFont = NSFont(name:"Ubuntu-Regular",size:10)!       // Font used when no style applied
    public static let kDefaultFontFamilyName = "Ubuntu        "                         // Font name used when no style applied
    public static let kDefaultFontSize:CGFloat = 12                             // Font size used when no style applied
    public static let kHeadlineFont = NSFont(name:"SunSans-Heavy",size:13)!     // Font applied to text marked as headline
    public static let kRowHeight:CGFloat = 24
    public static let kPrimaryTextColor = NSColor.argonDeepOrange               // Default foregorund color
    public static let kHeadlineTextColor = NSColor.argonSizzlingRed             // Foreground color applied  to text marked as headline
    public static let kDefaultShadowColor = NSColor.black                              // Actual color of the shadow
    public static let kDefaultCornerRadius:CGFloat = 10                                // The curve applied to border lines
    public static let kDefaultShadowOffset = CGSize(width:4,height:4)                  // The amount of space betwen the pane and it's shadow
    public static let kDefaultShadowRadius:CGFloat = 5                                 // The spill of the shadow
    public static let kPrimaryBorderColor = NSColor.argonNeonOrange             // Color of the the line around a border
    public static let kDefaultBorderWidth:CGFloat = 2                                  // Width of the line around a border
    public static let kDefaultBackgroundColor = NSColor.argonDarkGray           // Background color usedf wen none is specified
    public static let kDefaultPaneEdgePadding:CGFloat = 5                              // The size of the default borders around panes
    public static let kRowSpacerWidth:CGFloat = 2                               // The amount of space between adjacent rows in a row pane
    public static let kColumnSpacerWidth:CGFloat = 2                            // The amount of space between adjacent columns in a coumn pane
    public static let kDefaultPadding:CGFloat = 4
    public static let kTitleEdgePadding:CGFloat = 5                             // The padding around a title in a TitlePane
    public static let kDefaultShadowOpacity:CGFloat = 0.5
    
    public static let kDefaultBorderStyle = BorderStyle(borderColor:StylePalette.kPrimaryBorderColor,borderWidth:StylePalette.kDefaultBorderWidth,cornerRadius:StylePalette.kDefaultCornerRadius)
    
    public static func dumpAllFontNames()
        {
        for name in NSFontManager.shared.availableFontFamilies
            {
            for member in NSFontManager.shared.availableMembers(ofFontFamily: name)!
                {
                let array = member as NSArray
                print(array[0])
                }
            }
        }
        
    public enum StyleType
        {
        case none
        case text
        case border
        case area
        }
        
    public enum TextType
        {
        case body
        case title1
        case title2
        case emphasized
        case caption
        case callout
        }
        
    public class Style
        {
        }
        
    public class TextStyle:Style
        {
        let type:TextType
        let fontFamilyName:String
        let fontSize:CGFloat
        let font:NSFont?
        let foregroundColor:NSColor
        let backgroundColor:NSColor
        let fontTraitMask:NSFontTraitMask
        
        init(type:TextType,fontFamilyName:String = StylePalette.kDefaultFontFamilyName,fontSize:CGFloat = StylePalette.kDefaultFontSize,fontTraitMask:NSFontTraitMask,fontWeight:Int,foreground:NSColor,background:NSColor = StylePalette.kDefaultBackgroundColor)
            {
            self.type = type
            self.fontFamilyName = fontFamilyName
            self.fontSize = fontSize
            self.foregroundColor = foreground
            self.backgroundColor = background
            self.fontTraitMask = fontTraitMask
            self.font = NSFontManager.shared.font(withFamily: fontFamilyName, traits: fontTraitMask, weight: fontWeight, size: fontSize)
            }
            
        public func apply(to pane:TextPane)
            {
            if let font = self.font
                {
                pane.font = font
                }
            pane.textColor = self.foregroundColor
            pane.backgroundColor = self.backgroundColor.cgColor
            }
        }
        
    public class BorderStyle:Style
        {
        let borderColor:NSColor
        let borderWidth:CGFloat
        let cornerRadius:CGFloat
        let maskedCorners:CACornerMask
        let gutterWidth:CGFloat
        
        init(borderColor:NSColor,borderWidth:CGFloat = StylePalette.kDefaultBorderWidth,cornerRadius:CGFloat = StylePalette.kDefaultCornerRadius,maskedCorners:CACornerMask = [],gutterWidth:CGFloat = StylePalette.kDefaultPaneEdgePadding)
            {
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.cornerRadius = cornerRadius
            self.maskedCorners = maskedCorners
            self.gutterWidth = gutterWidth
            }
            
        public func apply(to pane:Pane)
            {
            pane.borderWidth = self.borderWidth
            pane.borderColor = self.borderColor.cgColor
            pane.cornerRadius = self.cornerRadius
            pane.maskedCorners = self.maskedCorners
            }
        }
        
    public class ShadowStyle:Style
        {
        let shadowColor:NSColor
        let shadowRadius:CGFloat
        let shadowOffset:NSSize
        let shadowOpacity:CGFloat
        
        init(shadowColor:NSColor,shadowRadius:CGFloat = StylePalette.kDefaultShadowRadius,shadowOffset:CGSize = StylePalette.kDefaultShadowOffset,shadowOpacity:CGFloat = StylePalette.kDefaultShadowOpacity)
            {
            self.shadowColor = shadowColor
            self.shadowRadius = shadowRadius
            self.shadowOffset = shadowOffset
            self.shadowOpacity = shadowOpacity
            }
        }
        
    private var textStyles:[TextType:TextStyle] = [:]
    
    init()
        {
        self.initStyles()
        }
        
    private func initStyles()
        {
        self.initTextStyles()
        }
        
    private func initTextStyles()
        {
        self.textStyles[.body] = TextStyle(type: .body, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kBodyFontSize, fontTraitMask: [], fontWeight: StylePalette.kBodyFontWeight, foreground: StylePalette.kPrimaryTextColor, background: NSColor.clear)
        self.textStyles[.title1] = TextStyle(type: .title1, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kTitle1FontSize, fontTraitMask: [.boldFontMask,.smallCapsFontMask], fontWeight: StylePalette.kTitle1FontWeight, foreground: StylePalette.kPrimaryTextColor, background: NSColor.clear)
        self.textStyles[.title2] = TextStyle(type: .title2, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kTitle2FontSize, fontTraitMask: [.boldFontMask], fontWeight: StylePalette.kTitle2FontWeight, foreground: StylePalette.kPrimaryTextColor, background: NSColor.clear)
        self.textStyles[.caption] = TextStyle(type: .caption, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kCaptionFontSize, fontTraitMask: [.boldFontMask], fontWeight: StylePalette.kCaptionFontWeight, foreground: StylePalette.kPrimaryTextColor, background: NSColor.clear)
        self.textStyles[.emphasized] = TextStyle(type: .emphasized, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kEmphasizedFontSize, fontTraitMask: [.italicFontMask], fontWeight: StylePalette.kEmphasizedFontWeight, foreground: StylePalette.kPrimaryTextColor, background: NSColor.clear)
        self.textStyles[.callout] = TextStyle(type: .callout, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kCalloutFontSize, fontTraitMask: [.boldFontMask], fontWeight: StylePalette.kCalloutFontWeight, foreground: StylePalette.kPrimaryTextColor, background: NSColor.clear)    
        }
    }
