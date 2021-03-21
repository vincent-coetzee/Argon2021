//
//  FileSymbol.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/02/25.
//

import Cocoa

public class ModuleWrapper
    {
    public let module:Module
    public let source:String
    
    init(module:Module,source:String)
        {
        self.module = module
        self.source = source
        }
    }
    
public class ArgonFile:Elemental,EditableItem
    {
    private let filename:String
    private let path:String
    private let pathExtension:String
    private var loadFailed = false
    private var sourceChanged = false
    private var module:Module?
    private var errors:[CompilerError] = []
    
    public var hasErrors:Bool
        {
        return(!self.errors.isEmpty)
        }
        
    public var errorAnnotations:[LineAnnotation]
        {
        var annotations:[LineAnnotation] = []
        
        for error in self.errors
            {
            let line = error.location.line
            annotations.append(LineAnnotation(line: line, icon: NSImage(named:"IconError64")!.tintedWith(.yellow).resized(to:NSSize(width:18,height:18))))
            }
        return(annotations)
        }
        
    private var _source:String = ""
        {
        didSet
            {
            let result = self.compile()
            if case let Result.failure(error) = result
                {
                print(error)
                }
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
    public func compile() -> Result<ModuleWrapper,CompilerError>
        {
        self.errors = []
        do
            {
            let compiler = try Compiler()
            let result = compiler.compile(source:self.source)
            if case let Result.failure(failureReason) = result
                {
                self.errors.append(failureReason)
                return(Result.failure(failureReason))
                }
            else if case let Result.success(aModule) = result
                {
                self.module = aModule
                }
            let module = self.module!
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: (self.module as Any), requiringSecureCoding: false)
                {
                let url = URL(fileURLWithPath: "/Users/vincent/Desktop/\(module.shortName).arb")
                try? data.write(to: url)
                return(Result.success(ModuleWrapper(module:module,source:self.source)))
                }
            let error = CompilerError(.unableToWriteTo("/Users/vincent/Desktop/\(module.shortName).arb"))
            self.errors.append(error)
            return(Result.failure(error))
            }
        catch let error as CompilerError
            {
            self.errors.append(error)
            return(Result.failure(error))
            }
        catch let error
            {
            return(Result.failure(CompilerError(error)))
            }
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
        
    public override func update(source:String?)
        {
        self._source = source ?? ""
        }
        
    public override func save()
        {
        if !self.loadFailed
            {
            try? self._source.write(toFile:self.path,atomically: true,encoding: String.Encoding.utf8)
            }
        }
    }

