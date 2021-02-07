//
//  Symbol.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Symbol:ParseNode
    {
    public enum ClassCode:Int
        {
        case none = 0
        case `class` = 1
        case module = 2
        case method = 3
        case methodInstance = 4
        case slot = 5
        case function = 6
        case value = 7
        }
        
    public static func classAtClassCode(_ id:ClassCode) throws -> Symbol.Type?
        {
        switch(id)
            {
            case .none:
                fatalError("This should not happen")
            case .class:
                return(Class.self)
            case .module:
                return(Module.self)
            case .slot:
                return(Slot.self)
            case .method:
                return(Method.self)
            case .methodInstance:
                return(MethodInstance.self)
            case .function:
                return(Function.self)
            case .value:
                return(ValueClass.self)
            }
        }
        
    public var sizeInBytes:Int
        {
        return(Word.kSizeInBytes)
        }
        
    public let id:UUID
    internal var shortName:String
    internal var wasDeclaredForward = false
    internal var references:[SourceReference] = []
    internal var accessLevel = AccessModifier.public
    internal var parent:Symbol?
    internal var definingScope:Scope?
    internal var memoryAddress:MemoryAddress = .zero
    internal var parentId:UUID?
    
    public var module:Module
        {
        var object = self.parent
        while object != nil && !(object is Module)
            {
            object = object?.parent
            }
        if object == nil
            {
            fatalError("Can not find containing module for \(self)")
            }
        return(object as! Module)
        }
        
    public var isPlaceholder:Bool
        {
        return(false)
        }
        
    internal var isScope:Bool
        {
        return(false)
        }
        
    internal var isMethod:Bool
        {
        return(false)
        }
        
    internal var isVariable:Bool
        {
        return(false)
        }
        
    internal var isClosure:Bool
        {
        return(false)
        }
        
    internal var typeName:String
        {
        return(self.shortName)
        }
        
    internal var type:Type
        {
        fatalError("This should have been overridden in a subclass")
        }
        
    internal var typeClass:Class
        {
        fatalError("This should have been overridden in a subclass")
        }
        
    internal var name:Name
        {
        let aName = self.parent?.name
        return(aName == nil ? Name(self.shortName) : (aName! + ("->" + self.shortName)))
        }
    
    public static func ==(lhs:Symbol,rhs:Symbol) -> Bool
        {
        return(lhs.index == rhs.index)
        }
        
    internal var isModuleLevelSymbol:Bool
        {
        return(false)
        }
        
    internal init(shortName:String = "",parent:Symbol? = nil)
        {
        self.shortName = shortName
        self.parent = parent
        self.parentId = self.parent?.id
        self.id = UUID()
        super.init()
        }
    
    internal init(name:Name,parent:Symbol? = nil)
        {
        self.shortName = name.first
        self.parent = parent
        self.parentId = self.parent?.id
        self.id = UUID()
        super.init()
        }

    internal func relinkSymbolsUsingIds(symbols:Dictionary<UUID,Symbol>)
        {
        if let anId = self.parentId,let symbol = symbols[anId]
            {
            self.parent = symbol
            }
        }
        
    internal func symbolsKeyedById() -> Dictionary<UUID,Symbol>
        {
        return(Dictionary<UUID,Symbol>())
        }
        
    internal func addRead(location:SourceLocation)
        {
        self.references.append(.read(location))
        }
        
    internal func addWrite(location:SourceLocation)
        {
        self.references.append(.write(location))
        }
    
    internal func addDeclaration(location:SourceLocation)
        {
        self.references.append(.declaration(location))
        }
        
    internal func lookup(name:Name) -> SymbolSet?
        {
        fatalError("\(#function) should have been overridden in a subclass of Symbol")
        }
        
    internal func symbolAdded(to node:ParseNode)
        {
        self.parent = node as? Symbol
        self.parentId = self.parent?.id
        }
        
    internal func typeCheck() throws
        {
        }
        
    internal func generateIntermediateCode(in:Module,codeHolder:CodeHolder,into buffer:A3CodeBuffer,using:Compiler) throws
        {
        }
        
    internal func  sourceFileElements() -> [SourceFileElement]
        {
        fatalError("This should be overridden")
        }
        
    internal func allocateAddresses(using compiler:Compiler) throws
        {
        }
    
    public func dump()
        {
        print("\(Swift.type(of:self)) \(self.shortName)")
        }
        
    public func encode(with coder: NSCoder)
        {
        coder.encode(self.id,forKey:"id")
        coder.encode(self.shortName,forKey:"shortName")
        coder.encode(self.wasDeclaredForward,forKey:"wasDeclaredForward")
        coder.encode(self.references.count,forKey:"referencesCount")
        for reference in self.references
            {
            reference.encode(with:coder)
            }
        coder.encode(self.accessLevel.rawValue,forKey:"accessLevel")
        coder.encode(self.parent,forKey:"parent")
        coder.encode(self.memoryAddress,forKey:"memoryAddress")
        }
    
    public required init?(coder: NSCoder)
        {
        self.id = coder.decodeObject(forKey:"id") as! UUID
        self.shortName = coder.decodeObject(forKey:"shortName") as! String
        self.wasDeclaredForward = coder.decodeBool(forKey:"wasDeclaredForward")
        let count = Int(coder.decodeInt64(forKey:"referencesCount"))
        for _ in 0..<count
            {
            self.references.append(SourceReference(coder:coder)!)
            }
        self.accessLevel = AccessModifier(rawValue: (coder.decodeObject(forKey:"accessLevel") as! String))!
        self.parent = coder.decodeObject(forKey:"parent") as? Symbol
        self.memoryAddress = coder.decodeObject(forKey:"memoryAddress") as! MemoryAddress
        }
    }

extension UUID
    {
    static let zero = Self(uuidString: "00000000-0000-0000-0000-000000000000")!
    }

public indirect enum StorageKind
    {
    case `nil`
    case string(String)
    case float(Argon.Float)
    case integer(Int)
    case uuid(UUID)
    case dictionary(Dictionary<String,StorageKind>)
    case array([StorageKind])
    

    public subscript(_ key:String) -> StorageKind
        {
        get
            {
            switch(self)
                {
                case .dictionary(let dict):
                    return(dict[key] ?? .nil)
                default:
                    fatalError()
                }
            }
        set
            {
            switch(self)
                {
                case .dictionary(var dict):
                    dict[key] = newValue
                    self = .dictionary(dict)
                default:
                    fatalError()
                }
            }
        }
        
    public subscript(_ key:Int) -> StorageKind
        {
        get
            {
            switch(self)
                {
                case .array(let array):
                    return(array[key])
                default:
                    fatalError()
                }
            }
        set
            {
            switch(self)
                {
                case .array(var array):
                    array[key] = newValue
                    self = .array(array)
                default:
                    fatalError()
                }
            }
        }
        
   public var integerKind:Int
    {
    switch(self)
        {
        case .integer(let dict):
            return(dict)
        default:
            fatalError("This should not be called on a \(self)")
        }
    }
    
   public var uuidKind:UUID
    {
    switch(self)
        {
        case .uuid(let dict):
            return(dict)
        default:
            fatalError("This should not be called on a \(self)")
        }
    }
    
   public var stringKind:String
    {
    switch(self)
        {
        case .string(let string):
            return(string)
        default:
            fatalError("This should not be called on a \(self)")
        }
    }
    
   public var arrayKind:Array<StorageKind>
    {
    switch(self)
        {
        case .array(let array):
            return(array)
        default:
            fatalError("This should not be called on a \(self)")
        }
    }
        
    public var dictionaryKind:Dictionary<String,StorageKind>
        {
        switch(self)
            {
            case .dictionary(let dict):
                return(dict)
            default:
                fatalError("This should not be called on a \(self)")
            }
        }
    }

public typealias StorageKindDictionary = Dictionary<String,StorageKind>

public typealias StorageKindArray = Array<StorageKind>

public typealias StorageDictionary = Dictionary<String,Any>

public typealias Storage = Any
