//
//  NSColor+Extensions.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/23.
//

import Cocoa

extension NSColor
    {
    public static let argonLawnGreen:NSColor = NSColor(hex: 0x7cfc00)
    public static var argonYellow:NSColor = NSColor(red:247,green:194,blue:66)
    public static let argonRed:NSColor = NSColor(red:215,green:74,blue:91)
    public static let argonCoral:NSColor = NSColor(red:238,green:135,blue:118)
    public static let argonPink:NSColor = NSColor(red:231,green:77,blue:144)
    public static let argonBlue:NSColor = NSColor(red:56,green:125,blue:127)
    public static let argonPurple:NSColor = NSColor(red:171,green:69,blue:228)
    public static let argonGreen:NSColor = NSColor(red:104,green:190,blue:157)
    public static let argonCyan:NSColor = NSColor(red:87,green:200,blue:188)
    public static let argonDeepOrange:NSColor = NSColor(hex: 0xFF8000)
    public static let argonCheese:NSColor = NSColor(hex: 0xffa600)
    public static let argonSizzlingRed:NSColor = NSColor(hex: 0xff3855)
    public static let argonCetaceanBlue:NSColor = NSColor(hex: 0x001440)
    public static let argonPomelo:NSColor = NSColor(hex: 0x408000)
    public static let argonPersianRose:NSColor = NSColor(hex: 0xfe28a2)
    public static let argonZomp:NSColor = NSColor(hex: 0x39a78e)
    public static let argonChartreuse:NSColor = NSColor(hex: 0xdfff00)
    public static let argonSalmonPink:NSColor = NSColor(hex: 0xff91a4)
    public static let argonNeonFuchsia:NSColor = NSColor(hex: 0xfe4164)
    public static let argonIvory:NSColor = NSColor(hex: 0xf5e1a4)
    public static let argonStoneTerrace:NSColor = NSColor(hex: 0xa09484)
    public static let argonBayside:NSColor = NSColor(hex: 0x5fc9bf)
    public static let argonMangoGreen:NSColor = NSColor(hex: 0x96ff00)
    public static let argonSeaGreen:NSColor = NSColor(hex: 0x007563)
    public static let argonDarkGray:NSColor = NSColor(hex: 0x121212)
    public static let argonNeonYellow:NSColor = NSColor(hex: 0xF3F315)
    public static let argonNeonOrange = NSColor(red: 237.0/255.0,green: 111.0/255.0,blue:45.0/255.0,alpha:1)
    public static let argonNeonGreen = NSColor(red: 128.0/255.0,green: 189.0/255.0,blue:4.0/255.0,alpha:1)
    public static let argonPlainPink = NSColor(red: 255.0/255.0,green: 0.0/255.0,blue:123.0/255.0,alpha:1)
    public static let argonKeywordGreen = NSColor(red: 0/255.0,green: 144/255.0,blue:99/255.0,alpha:1)
    public static let argonConstantBlue = NSColor(red: 0/255.0,green: 195.0/255.0,blue:175.0/255.0,alpha:1)
    public static let argonNamingYellow = NSColor(red: 255.0/255.0,green: 181.0/255.0,blue:0.0/255.0,alpha:1)
    public static let argonLime = NSColor(red: 122.0/255.0,green: 154.0/255.0,blue:1.0/255.0,alpha:1)
    public static let argonNeonPink = NSColor(red: 255.0/255.0,green: 0/255.0,blue:153.0/255.0,alpha:1)
    public static let argonSexyPink = NSColor(red: 255.0/255.0,green: 63/255.0,blue:131/255.0,alpha:1)
        
    convenience init(red:Int,green:Int,blue:Int)
        {
        self.init(red: CGFloat(red)/255.0,green: CGFloat(green)/255.0,blue:CGFloat(blue)/255.0,alpha: 1.0)
        }
        
    convenience init(hex:Int)
        {
        print(hex)
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        self.init(red: CGFloat(red)/255.0,green: CGFloat(green)/255.0,blue:CGFloat(blue)/255.0,alpha: 1.0)
        }
    }
