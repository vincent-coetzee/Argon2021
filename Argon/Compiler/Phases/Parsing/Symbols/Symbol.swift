//
//  Symbol.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Symbol:ParseNode,Equatable,Hashable,Codable
    {
    enum CodingKeys:String,CodingKey
        {
        case shortName
        case id
        case references
        case accessLevel
        case parent
        case definingScope
        }
        
    public var sizeInBytes:Int
        {
        return(Word.kSizeInBytes)
        }
        
    public var className:String
        {
        return("\(Swift.type(of:self))")
        }
        
    public let id:UUID
    internal var shortName:String
    internal var wasDeclaredForward = false
    internal var references:[SourceReference] = []
    internal var accessLevel = AccessModifier.public
    internal var parent:Symbol?
    internal var definingScope:Scope?
    internal var memoryAddress:MemoryAddress = .zero
    
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
        self.id = UUID()
        super.init()
        }
    
    internal init(name:Name,parent:Symbol? = nil)
        {
        self.shortName = name.first
        self.parent = parent
        self.id = UUID()
        super.init()
        }
        
    required public init(from decoder:Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.shortName = try values.decode(String.self,forKey: .shortName)
        self.id = try values.decode(UUID.self,forKey: .id)
        self.references = try values.decode(Array<SourceReference>.self,forKey:.references)
        self.accessLevel = try values.decode(AccessModifier.self,forKey:.accessLevel)
        self.parent = try values.decode(Symbol?.self,forKey:.parent)
//        self.definingScope = try values.decode(Scope?.self,forKey:.definingScope)
        }
        
    public func encode(to encoder: Encoder) throws
        {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.shortName,forKey:.shortName)
        try container.encode(self.id,forKey:.id)
        try container.encode(self.references,forKey:.references)
        try container.encode(self.accessLevel,forKey:.accessLevel)
        try container.encode(parent,forKey:.parent)
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
        
    public func hash(into hasher: inout Hasher)
        {
        hasher.combine(self.shortName)
        hasher.combine(self.index)
        }
        
    internal func symbolAdded(to node:ParseNode)
        {
        self.parent = node as? Symbol
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
    }
