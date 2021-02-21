//
//  BrowserItem.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Cocoa

public protocol BrowserItem
    {
//    var browserCell:NSBrowserCell { get }
    var isLeaf:Bool { get }
    var title:String { get }
    var image:NSImage { get }
    var childCount:Int { get }
    func child(at:Int) -> BrowserItem
    }
    
