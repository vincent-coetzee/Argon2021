//
//  FileSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/25.
//

import Cocoa

public class ArgonFile:BrowsableItem,EditableItem
    {
    private let filename:String
    private let path:String
    private let pathExtension:String
    private var loadFailed = false
    private var sourceChanged = false
    
    public var source:String = ""
        {
        didSet
            {
            self.sourceChanged = true
            }
        }
        
    public var isLeaf:Bool
        {
        return(true)
        }
        
    public var childCount:Int
        {
        return(0)
        }
        
    public func child(at:Int) -> BrowsableItem
        {
        fatalError("This method \(#function) should not be called on an ArgonFile")
        }
        
    public func localSymbols(_ kinds:SymbolKind...) -> Array<Symbol>
        {
        fatalError("This method \(#function) should not be called on an ArgonFile")
        }
        
    public func buildSymbols()
        {
        fatalError("This method \(#function) should not be called on an ArgonFile")
        }
        
    public func menu(for event:NSEvent,in row:Int,on item:BrowsableItem) -> NSMenu?
        {
        return(nil)
        }
        

    public var browserCell: ItemBrowserCell
        {
       return(ArgonFileItemBrowserCell(item:self))
        }
        
    public var editorCell:ItemEditorCell
        {
        return(SourceFileItemEditorCell(item:self))
        }
        
    public var title:String
        {
        return(self.filename)
        }
        
    public var icon:NSImage
        {
        return(NSImage(named:"IconFile64")!)
        }

    init(path:String)
        {
        self.filename = (path as NSString).lastPathComponent
        self.pathExtension = (path as NSString).pathExtension
        self.path = path
        if let string = try? String(contentsOfFile: self.path)
            {
            self.source = string
            }
        else
            {
            self.loadFailed = true
            }
        }
    }

