//
//  Package.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Cocoa

public class Module:SymbolContainer,NSCoding
    {
    public override var symbolKind:SymbolKind
        {
        return(.module)
        }
        
    public static func initModules()
        {
        let _ = Module.rootModule
        let _ = Module.argonModule
        let _ = Module.argonModule.initArgonModule()
        }
        
    public static let argonModule = ArgonModule(shortName: "Argon")
    public static let rootModule = RootModule(shortName: "Root")
    public static let rootScope = Module.rootModule
        
    internal override func pushScope()
        {
        self.push()
        }
    
    internal override func popScope()
        {
        self.pop()
        }
        
    public private(set) var genericTypes:[TypeVariable] = []
    private var exitFunction:ModuleFunction?
    private var entryFunction:ModuleFunction?
    public var moduleKey = UUID()
    private var versionKey:SemanticVersionNumber = .one
    private var moduleSlots:Dictionary<String,Slot> = [:]
    private var imports = ImportVector()
    
    public override func buildSymbols()
        {
        var classes = self.symbols.values.reduce(into: Array<Symbol>()){$0.append(contentsOf:$1.symbols)}.filter{$0 is Class && !($0 is Enumeration)}
        var classesToRemove = Array<Symbol>()
        for aClass in classes
            {
            for superclass in (aClass as! Class).superclasses
                {
                if classes.contains(superclass)
                    {
                    classesToRemove.append(aClass)
                    }
                }
            }
        classes.removeAll(where: {classesToRemove.contains($0)})
        let enumerations = self.symbols.values.reduce(into: Array<Symbol>()){$0.append(contentsOf:$1.symbols)}.filter{$0 is Enumeration}
        let methods = self.symbols.values.reduce(into: Array<Symbol>()){$0.append(contentsOf:$1.symbols)}.filter{$0 is Method}
        let modules = self.symbols.values.reduce(into: Array<Symbol>()){$0.append(contentsOf:$1.symbols)}.filter{$0 is Module}
        self.allSymbols = modules.sorted{$0.shortName<$1.shortName} + classes.sorted{$0.shortName<$1.shortName} + enumerations.sorted{$0.shortName<$1.shortName} + methods.sorted{$0.shortName<$1.shortName}
        }

    public func reset()
        {
        self.allSymbols = []
        self.symbols = [:]
        }
    public override var isModuleLevelSymbol:Bool
        {
        return(true)
        }
        
    public override var image: NSImage
        {
        return(NSImage(named:"IconModule64")!)
        }
        
    public var isRootModule:Bool
        {
        return(false)
        }
        
    public var isArgonModule:Bool
        {
        return(false)
        }
        
    internal override func relinkSymbolsUsingIds(symbols:Dictionary<UUID,Symbol>)
        {
        super.relinkSymbolsUsingIds(symbols:symbols)
        for slot in self.moduleSlots.values
            {
            slot.containingSymbol = self
            }
        }
        
    internal override func addSymbol(_ symbol:Symbol)
        {
        symbol.definingScope = self
        if symbol is Slot
            {
            self.moduleSlots[symbol.shortName] = (symbol as! Slot)
            return
            }
        else if symbol is Import
            {
            self.imports += symbol as! Import
            return
            }
        super.addSymbol(symbol)
        symbol.symbolAdded(to: self)
        }
        
    public override func accept(_ visitor:SymbolVisitor)
        {
        visitor.acceptModule(self)
        }
        
    internal func lookupClass(_ name:String) -> Class?
        {
        return(self.lookup(name: Name(name))?.first as? Class)
        }
        
    internal func lookupModule(_ name:String) -> Module?
        {
        return(self.lookup(name: Name(name))?.first as? Module)
        }
        
    internal override func lookup(name inputName:Name) -> SymbolSet?
        {
        var entity:Symbol? = inputName.isAnchored ? Module.rootModule : self
        var name = inputName
        while !name.isEmpty && entity != nil
            {
            if let object = entity?.lookup(shortName: name.first)?.first
                {
                entity = object
                name = name.withoutFirst()
                }
            else
                {
                entity = nil
                }
            }
        entity = entity == nil ? self.imports.lookup(name:inputName)?.first : entity
        return(entity == nil ? nil : SymbolSet(entity!))
        }
        
    internal override var typeClass:Class
        {
        return(ModuleClass(shortName:self.shortName))
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        if let set = super.lookup(shortName: shortName)
            {
            return(set)
            }
        if self.parentScope == nil && !self.isArgonModule
            {
            if let set = Module.argonModule.lookup(shortName: shortName)
                {
                return(set)
                }
            }
        return(self.parentScope?.lookup(shortName: shortName))
        }
        
    public override func lookupMethod(shortName:String) -> Method?
        {
        if let set = self.lookup(shortName:shortName)
            {
            for symbol in set.symbols
                {
                if let method = symbol as? Method
                    {
                    return(method)
                    }
                }
            }
        return(nil)
        }
        
    internal override func addSymbol(_ symbol:Symbol,atName name:Name) throws
        {
        if let entity = Module.rootScope.lookup(name: name.withoutLast())?.first
            {
            symbol.shortName = name.last
            entity.addSymbol(symbol)
            }
        else
            {
            throw(CompilerError(.nameCanNotBeFound(name),SourceLocation.zero))
            }
        }
        
    func setEntry(_ function:ModuleFunction)
        {
        self.entryFunction = function
        }
        
    func setExit(_ function:ModuleFunction)
        {
        self.exitFunction = function
        }
        
    internal override func typeCheck() throws
        {
        for symbolSet in self.symbols.values
            {
            try symbolSet.typeCheck()
            }
        }
        
    @discardableResult
    func placeholderMethodInstance(_ name:String,_ returnType:Class = .voidClass,_ parameters:Parameter...) -> Self
        {
        var genericMethod:Method
        if let method = self.lookup(shortName:name)?.first as? Method
            {
            genericMethod = method
            }
        else
            {
            genericMethod = SystemPlaceholderMethod(shortName:name)
            genericMethod.accessLevel = .export
            self.addSymbol(genericMethod)
            }
        let instance = SystemPlaceholderMethodInstance(shortName: name)
        instance.parameters = parameters
        instance.returnTypeClass = returnType
        genericMethod.addInstance(instance)
        return(self)
        }
        
    @discardableResult
    func placeholderClass(_ name:String,parents:[Class]) -> Class
        {
        let aClass = SystemPlaceholderClass(shortName: name)
        aClass.accessLevel = .export
        aClass.superclasses = parents
        for parent in parents
            {
            parent.subclasses.insert(aClass)
            }
        self.addSymbol(aClass)
        return(aClass)
        }
        
    @discardableResult
    func placeholderSlot(_ name:String,`class`:Class,attributes:SlotAttributes = [.class]) -> Module
        {
        let slot = SystemPlaceholderSlot(shortName:name,class: `class`,container:self,attributes: attributes)
        slot.accessLevel = .protected
        self.addSymbol(slot)
        return(self)
        }
        
    @discardableResult
    func placeholderEnumeration(_ name:String,`class`:Class) -> Enumeration
        {
        let anEnum = SystemPlaceholderEnumeration(shortName:"ConduitSink",class:.uIntegerClass)
        anEnum.accessLevel = .export
        return(anEnum)
        }
        
    internal override func allocateAddresses(using compiler:Compiler) throws
        {
        compiler.staticSegment.updateAddress(self)
        }
        
    internal override func generateIntermediateCode(in:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        }
        
    public override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.memoryAddress = .zero
        }
        
    public override func encode(with coder: NSCoder)
        {
        coder.encode(self.moduleKey,forKey:"moduleKey")
        let allSymbols = self.symbols.values.flatMap{$0.symbols}
        coder.encode(allSymbols,forKey:"allSymbols")
        }
    
    public required init?(coder: NSCoder)
        {
        self.moduleKey = coder.decodeObject(forKey: "moduleKey") as! UUID
        let allSymbols = coder.decodeObject(forKey: "allSymbols") as! Array<Symbol>
        super.init(coder:coder)
        for symbol in allSymbols
            {
            self.addSymbol(symbol)
            }
        }
        
    public override var isLeaf: Bool
        {
        return(false)
        }

    public override var childCount: Int
        {
        return(self.allSymbols.count)
        }
    
    public override func child(at: Int) -> OutlineItem
        {
        return(self.allSymbols[at])
        }
        
    public var rootClass:Class
        {
        let classes = self.allClasses
        let roots = classes.filter{($0 as! Class).superclasses.isEmpty}
        if roots.count > 1
            {
            fatalError("There should only be one root")
            }
        return(roots[0] as! Class)
        }
        
    public override var allClasses:Array<Symbol>
        {
        let allElements = self.symbols.values.reduce(into:[]){$0.append(contentsOf:$1.symbols)}
        let modules = allElements.filter{$0 is Module}.map{$0 as! Module}
        var classes = Array<Symbol>()
        for module in modules
            {
            let newClasses = module.allClasses
            classes.append(contentsOf: newClasses)
            }
        classes.append(contentsOf:allElements.filter{$0 is Class}.map{$0 as! Class})
        return(classes.sorted{$0.shortName<$1.shortName})
        }
    }

public class ModuleClass:Class
    {
    public static func ==(lhs:ModuleClass,rhs:Class) -> Bool
        {
        return(Swift.type(of:rhs)==Swift.type(of:lhs) && rhs.shortName == lhs.shortName)
        }
    }

public class ImportedModuleReference:Module
    {
    public override var fullName:Name
        {
        return(self.parent?.fullName ?? Name() + self.shortName)
        }
        
    internal override func lookupClass(_ name:String) -> Class?
        {
        if let aClass = super.lookupClass(name)
            {
            return(aClass)
            }
        let newClass = ImportedClassReference(shortName:name)
        self.addSymbol(newClass)
        return(newClass)
        }
        
    internal func lookupClass(_ name:Name) -> Class?
        {
        if let set = super.lookup(name:name)
            {
            return(set.symbols.first as? Class)
            }
        let newClass = ImportedClassReference(shortName:name.last)
        let newName = name.withoutLast()
        let thisName = newName.last
        if thisName != self.shortName
            {
            fatalError("lookup of name failed \(name)")
            }
        self.addSymbol(newClass)
        return(newClass)
        }
    }

public class RootModule:Module
    {
    public override var isRootModule:Bool
        {
        return(true)
        }
        
    public override var fullName:Name
        {
        return(Name(anchored:true))
        }
    }
