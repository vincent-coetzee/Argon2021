//
//  FileSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/25.
//

import Cocoa

public class ArgonFile:Elemental,EditableItem
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
        
    public override var childCount:Int
        {
        return(0)
        }
        
    public override subscript(_ index:Int) -> Elemental
        {
        fatalError("This method \(#function) should not be called on an ArgonFile")
        }
        
    public func menu(for event:NSEvent,in row:Int,on item:Elemental) -> NSMenu?
        {
        return(nil)
        }
        

    public override var browserCell: ItemBrowserCell
        {
       return(ArgonFileItemBrowserCell(item:self))
        }
        
    public var editorCell:ItemEditorCell
        {
        return(SourceFileItemEditorCell(item:self))
        }
        
    public override var title:String
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

