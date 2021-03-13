//
//  RowWrapper.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/07.
//

import Cocoa


public class RowWrapper
    {
    public static let kDefaultFont = NSFont(name:"SunSans-Demi",size:12)!
    public static let kRowHeight:CGFloat = 18
    
    public var primaryColor:NSColor = NSColor.white
        
    public var isExpandable:Bool
        {
        return(false)
        }
        
    public func rowView() -> NSView
        {
        fatalError()
        }
        
    public var rowHeight:CGFloat
        {
        return(18)
        }
        
    public var count:Int
        {
        fatalError()
        }
        
    public func child(atIndex index:Int) -> RowWrapper
        {
        fatalError()
        }
        
    public func measureText(_ text:String,inFont:NSFont = NSFont(name:"SunSans-Demi",size:12)!) -> NSSize
        {
        let attributes:[NSAttributedString.Key:Any] = [.font:inFont]
        let string = NSAttributedString(string:text,attributes:attributes)
        return(string.size())
        }
    }



