//
//  StylePalette.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa
    
public protocol TextStylable
    {
    var textType:StylePalette.TextType { get }
    var textColor:NSColor { get set }
    var textFont:NSFont { get set }
    }
    
public typealias PaneStyle = StylePalette.CompositeStyle

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
    
    public static let kDefaultFont = NSFont(name:"Ubuntu-Regular",size:11)!       // Font used when no style applied
    public static let kDefaultFontFamilyName = "Ubuntu        "                         // Font name used when no style applied
    public static let kDefaultFontSize:CGFloat = 12                             // Font size used when no style applied
    public static let kHeadlineFont = NSFont(name:"Ubuntu-Bold",size:14)!     // Font applied to text marked as headline
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
    public static let kDefaultShadowOpacity:Float = 0.5
    
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
        case text(TextType)
        case border
        case ground
        case composite
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
        let textColor:NSColor
        let backgroundColor:NSColor
        let fontTraitMask:NSFontTraitMask
        
        init(type:TextType,fontFamilyName:String = StylePalette.kDefaultFontFamilyName,fontSize:CGFloat = StylePalette.kDefaultFontSize,fontTraitMask:NSFontTraitMask,fontWeight:Int,textColor:NSColor,backgroundColor:NSColor = StylePalette.kDefaultBackgroundColor)
            {
            self.type = type
            self.fontFamilyName = fontFamilyName
            self.fontSize = fontSize
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.fontTraitMask = fontTraitMask
            self.font = NSFontManager.shared.font(withFamily: fontFamilyName, traits: fontTraitMask, weight: fontWeight, size: fontSize)
            }
            
        public func apply(to pane:TextPane)
            {
            if let font = self.font
                {
                pane.font = font
                }
            pane.textColor = self.textColor
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
        let shadowOpacity:Float
        
        init(shadowColor:NSColor,shadowRadius:CGFloat = StylePalette.kDefaultShadowRadius,shadowOffset:CGSize = StylePalette.kDefaultShadowOffset,shadowOpacity:Float = StylePalette.kDefaultShadowOpacity)
            {
            self.shadowColor = shadowColor
            self.shadowRadius = shadowRadius
            self.shadowOffset = shadowOffset
            self.shadowOpacity = shadowOpacity
            }
            
        public func apply(to pane:Pane)
            {
            pane.shadowColor = self.shadowColor.cgColor
            pane.shadowRadius = self.shadowRadius
            pane.shadowOffset = self.shadowOffset
            pane.shadowOpacity = self.shadowOpacity
            }
        }
        
    public class GroundStyle:Style
        {
        let backgroundColor:NSColor
        
        init(backgroundColor:NSColor)
            {
            self.backgroundColor = backgroundColor
            }
            
        public func apply(to pane:Pane)
            {
            pane.backgroundColor = self.backgroundColor.cgColor
            }
        }
        
    public class CompositeStyle:Style
        {
        var textStyles:[TextType:TextStyle] = [:]
        let borderStyle:BorderStyle
        let groundStyle:GroundStyle
        
        init(texts:Array<TextStyle>,border:BorderStyle,ground:GroundStyle)
            {
            for text in texts
                {
                self.textStyles[text.type] = text
                }
            self.borderStyle = border
            self.groundStyle = ground
            }
            
        public func apply(to pane:Pane)
            {
            self.borderStyle.apply(to: pane)
            self.groundStyle.apply(to: pane)
            }
            
        public func apply<P>(to aPane: P) where P:TextStylable
            {
            var pane = aPane
            if let style = self.textStyles[pane.textType]
                {
                pane.textColor = style.textColor
                if let font = style.font
                    {
                    pane.textFont = font
                    }
                }
            }
        }
        
    public let paneStyle:PaneStyle
    
    init()
        {
        var textStyles:[TextType:TextStyle] = [:]
        textStyles[.body] = TextStyle(type: .body, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kBodyFontSize, fontTraitMask: [], fontWeight: StylePalette.kBodyFontWeight, textColor: StylePalette.kPrimaryTextColor, backgroundColor: NSColor.clear)
        textStyles[.title1] = TextStyle(type: .title1, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kTitle1FontSize, fontTraitMask: [.boldFontMask,.smallCapsFontMask], fontWeight: StylePalette.kTitle1FontWeight, textColor: StylePalette.kPrimaryTextColor, backgroundColor: NSColor.clear)
        textStyles[.title2] = TextStyle(type: .title2, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kTitle2FontSize, fontTraitMask: [.boldFontMask], fontWeight: StylePalette.kTitle2FontWeight, textColor: StylePalette.kPrimaryTextColor, backgroundColor: NSColor.clear)
        textStyles[.caption] = TextStyle(type: .caption, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kCaptionFontSize, fontTraitMask: [.boldFontMask], fontWeight: StylePalette.kCaptionFontWeight, textColor: StylePalette.kPrimaryTextColor, backgroundColor: NSColor.clear)
        textStyles[.emphasized] = TextStyle(type: .emphasized, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kEmphasizedFontSize, fontTraitMask: [.italicFontMask], fontWeight: StylePalette.kEmphasizedFontWeight, textColor: StylePalette.kPrimaryTextColor, backgroundColor: NSColor.clear)
        textStyles[.callout] = TextStyle(type: .callout, fontFamilyName: StylePalette.kDefaultFontFamilyName, fontSize: StylePalette.kCalloutFontSize, fontTraitMask: [.boldFontMask], fontWeight: StylePalette.kCalloutFontWeight, textColor: StylePalette.kPrimaryTextColor, backgroundColor: NSColor.clear)
        let borderStyle = BorderStyle(borderColor: StylePalette.kPrimaryBorderColor, borderWidth: StylePalette.kDefaultBorderWidth, cornerRadius: StylePalette.kDefaultCornerRadius, maskedCorners: [], gutterWidth: StylePalette.kTitleEdgePadding)
        let groundStyle = GroundStyle(backgroundColor: .black)
        self.paneStyle = CompositeStyle(texts: Array(textStyles.values), border: borderStyle, ground: groundStyle)
        }
        
    private func initStyles()
        {
        
        self.initTextStyles()
        }
        
    private func initTextStyles()
        {
        }
    }
