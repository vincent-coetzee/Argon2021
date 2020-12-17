//
//  NSColor.swift
//  Argon
//
//  Created by Vincent Coetzee on 2020/12/11.
//

import AppKit

extension NSColor
    {
    static var argonYellow:NSColor
        {
        return(NSColor(red:247,green:194,blue:66))
        }
        
    static var argonRed:NSColor
        {
        return(NSColor(red:215,green:74,blue:91))
        }
        
    static var argonCoral:NSColor
        {
        return(NSColor(red:238,green:135,blue:118))
        }
        
    static var argonPink:NSColor
        {
        return(NSColor(red:231,green:77,blue:144))
        }
        
    static var argonBlue:NSColor
        {
        return(NSColor(red:56,green:125,blue:127))
        }
        
    static var argonPurple:NSColor
        {
        return(NSColor(red:171,green:69,blue:228))
        }
        
    static var argonGreen:NSColor
        {
        return(NSColor(red:104,green:190,blue:157))
        }
        
    static var argonCyan:NSColor
        {
        return(NSColor(red:87,green:200,blue:188))
        }
        
    convenience init(red:Int,green:Int,blue:Int)
        {
        self.init(red: CGFloat(red)/255.0,green: CGFloat(green)/255.0,blue:CGFloat(blue)/255.0,alpha: 1.0)
        }
        
    static var keywordColor:NSColor
        {
        return(NSColor(red: 0.8,green: 0.95,blue: 0.95,alpha: 1.0))
        }
        
    static var identifierColor:NSColor
        {
        return(NSColor(red: 0.8,green: 0.8,blue: 0.95,alpha: 1.0))
        }
        
    static var symbolColor:NSColor
        {
        return(NSColor(red: 0.4,green: 0.4,blue: 0.95,alpha: 1.0))
        }
        
    static var nativeTypeColor:NSColor
        {
        return(NSColor(red: 0.2,green: 0.4,blue: 0.4,alpha: 1.0))
        }
        
    static var commentColor:NSColor
        {
        return(NSColor(red: 0.5,green: 0.1,blue: 0.5,alpha: 1.0))
        }
    }
