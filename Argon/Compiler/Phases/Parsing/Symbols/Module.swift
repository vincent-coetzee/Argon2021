//
//  Package.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Module:SymbolContainer
    {
    public static let rootModule = RootModule(shortName: "Argon")
        
    public static let rootScope = Module.rootModule
        
    public var exportedSymbols:[Symbol]
        {
        return(self.symbols.values.flatMap{$0.symbols}.filter{$0.accessLevel == .export})
        }
        
    internal override func pushScope()
        {
        self.push()
        }
    
    internal override func popScope()
        {
        self.pop()
        }
    
    public private(set) var genericTypes:[GenericClass] = []
    private var exitFunction:ModuleFunction?
    private var entryFunction:ModuleFunction?
    public var moduleKey = UUID()
    private var versionKey:SemanticVersionNumber = .one
    private var moduleSlots:Dictionary<String,Slot> = [:]
    private var imports = ImportVector()
        
    enum CodingKeys:String,CodingKey
        {
        case genericTypes
        case exitFunction
        case entryFunction
        case moduleKey
        case versionKey
        case moduleSlots
        case imports
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.genericTypes = try values.decode(Array<GenericClass>.self,forKey: .genericTypes)
//        self.exitFunction = try values.decode(ModuleFunction?.self,forKey: .exitFunction)
//        self.entryFunction = try values.decode(ModuleFunction?.self,forKey:.entryFunction)
        self.moduleKey = try values.decode(UUID.self,forKey:.moduleKey)
        self.versionKey = try values.decode(SemanticVersionNumber.self,forKey:.versionKey)
        self.moduleSlots = try values.decode(Dictionary<String,Slot>.self,forKey:.moduleSlots)
        self.imports = try values.decode(ImportVector.self,forKey:.imports)
        try super.init(from:values.superDecoder())
        self.memoryAddress = Compiler.shared.staticSegment.zero
        }
        
    public override func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.genericTypes,forKey:.genericTypes)
//        try container.encode(self.exitFunction,forKey:.exitFunction)
//        try container.encode(self.entryFunction,forKey:.entryFunction)
        try container.encode(self.moduleKey,forKey:.moduleKey)
        try container.encode(versionKey,forKey:.versionKey)
        try container.encode(self.moduleSlots,forKey:.moduleSlots)
        try container.encode(imports,forKey:.imports)
        try super.encode(to: container.superEncoder())
        }
        
    public override var isModuleLevelSymbol:Bool
        {
        return(true)
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
        
    internal func lookupClass(_ name:String) -> Class?
        {
        return(self.lookup(name: Name(name))?.first as? Class)
        }
        
    internal func lookupModule(_ name:String) -> Module?
        {
        return(self.lookup(name: Name(name))?.first as? Module)
        }
        
    internal override func lookup(name:Name) -> SymbolSet?
        {
        var theName = name
        var entity:Symbol? = self
        while !theName.isEmpty && entity != nil
            {
            if let object = entity?.lookup(shortName: theName.first)?.first
                {
                entity = object
                theName = theName.withoutFirst()
                }
            else
                {
                entity = nil
                }
            }
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
        return(self.parentScope?.lookup(shortName: shortName))
        }
        
    internal func addSymbol(_ symbol:Symbol,atName name:Name) throws
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
        
    public override func dump()
        {
        print("Module \(self.shortName)")
        for symbolSet in self.symbols.values
            {
            for symbol in symbolSet.symbols
                {
                symbol.dump()
                }
            }
        }
        
    public override init(shortName:String)
        {
        super.init(shortName:shortName)
        self.memoryAddress = Compiler.shared.staticSegment.zero
        }
    }

public class ModuleClass:Class
    {
    public static func ==(lhs:ModuleClass,rhs:Class) -> Bool
        {
        return(Swift.type(of:rhs)==Swift.type(of:lhs) && rhs.shortName == lhs.shortName)
        }
    }
