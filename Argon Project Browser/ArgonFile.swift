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
    private var module:TopModule?
    
    private var _source:String = ""
        {
        didSet
            {
            self.compile()
            }
        }
        
    public override var hasSource:Bool
        {
        return(true)
        }
        
    public override var source:String
        {
        return(self._source)
        }
        
    public var isLeaf:Bool
        {
        return(true)
        }
        
    public override var isExpandable:Bool
        {
        return(self.module == nil ? false : true)
        }
        
    public var elementals:Elementals
        {
        if let module = self.module
            {
            return([ElementalSymbol(symbol:module)])
            }
        return([])
        }
        
    @discardableResult
    public func compile() -> Module?
        {
        let compiler = Compiler()
        self.module = compiler.compile(source:self.source)
        self.module?.path = path
        if let module = self.module,let data = try? NSKeyedArchiver.archivedData(withRootObject: self.module, requiringSecureCoding: false)
            {
            let url = URL(fileURLWithPath: "/Users/vincent/Desktop/\(module.shortName).arb")
            try? data.write(to: url)
            }
        return(self.module)
        }
        
    public override var childCount:Int
        {
        return(self.elementals.count)
        }
        
    public override subscript(_ index:Int) -> Elemental
        {
        return(self.elementals[index])
        }
        
    public func menu(for event:NSEvent,in row:Int,on item:Elemental) -> NSMenu?
        {
        return(nil)
        }
        

    public override var browserCell: ItemBrowserCell
        {
       return(ItemFileBrowserCell(item:self))
        }
        
    public override var editorCell:ItemEditorCell
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
            self._source = string
            }
        else
            {
            self.loadFailed = true
            }
        }
    }

