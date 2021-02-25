//
//  BrowserItem.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/21.
//

import Cocoa

public protocol BrowsableItem
    {
    var browserCell:ItemBrowserCell { get }
    var editorCell:ItemEditorCell { get }
    var isLeaf:Bool { get }
    var title:String { get }
    var icon:NSImage { get }
    var childCount:Int { get }
    func child(at:Int) -> BrowsableItem
    func localSymbols(_ kinds:SymbolKind...) -> Array<Symbol>
    func buildSymbols()
    func menu(for event:NSEvent,in row:Int,on item:BrowsableItem) -> NSMenu?
    }
    
