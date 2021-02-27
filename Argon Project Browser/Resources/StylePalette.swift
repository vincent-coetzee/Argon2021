//
//  StylePalette.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/26.
//

import Cocoa

public struct StylePalette
    {
    public static let kDefaultFont = NSFont(name:"SunSans-Demi",size:12)!
    public static let kHeadlineFont = NSFont(name:"SunSans-Heavy",size:20)!
    public static let kRowHeight:CGFloat = 24
    public static let kPrimaryTextColor = NSColor.argonDeepOrange
    public static let kHeadlineTextColor = NSColor.argonSizzlingRed
    public static let kShadowColor = NSColor.black
    public static let kCornerRadius:CGFloat = 10
    public static let kShadowOffset = CGSize(width:4,height:4)
    public static let kShadowRadius:CGFloat = 5
    public static let kPrimaryBorderColor = NSColor.argonNeonOrange
    public static let kBorderWidth:CGFloat = 2
    public static let kDefaultBackgroundColor = NSColor.argonDarkGray
    public static let kPaneBorderWidth:CGFloat = 5
    public static let kRowSpacerWidth:CGFloat = 2
    public static let kColumnSpacerWidth:CGFloat = 2
    }
