//
//  BrowserItem.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Cocoa

public protocol OutlineItem
    {
    var itemClass:OutlineItemCell.Type { get }
    var isLeaf:Bool { get }
    var title:String { get }
    var image:NSImage { get }
    var childCount:Int { get }
    func child(at:Int) -> OutlineItem
    func localSymbols(_ kinds:SymbolKind...) -> Array<Symbol>
    func buildSymbols()
    }
    
