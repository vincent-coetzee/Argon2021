//
//  Symbol.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Cocoa
    
public typealias Symbols = Array<Symbol>

public class Symbol:ParseNode,SymbolVisitorAcceptor,Browsable
    {
    public static func ==(lhs:Symbol,rhs:Symbol) -> Bool
        {
        return(lhs.id == rhs.id)
        }
    
    public override var debugDescription: String
        {
        return("\(Swift.type(of:self))(\(self.shortName))")
        }
        
    public var completeName:String
        {
        return(self.fullName.stringName)
        }
        
    public let id:UUID
    internal var shortName:String
    internal var wasDeclaredForward = false
    internal var references:[SourceReference] = []
    internal var accessLevel = AccessModifier.public
    internal var memoryAddress:MemoryAddress = .zero
    internal var parentId:UUID?
    internal var _elementals:Elementals?
    public var container:SymbolContainer = .nothing
    
    public var symbolTable:SymbolTable?
        {
        return(nil)
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
        
    internal var typeClass:Class
        {
        fatalError("This should have been overridden in a subclass")
        }
        
    public var fullName:Name
        {
        return(self.container.fullName + self.shortName)
        }
        
    internal var isModuleLevelSymbol:Bool
        {
        return(false)
        }
        
    public var browserCell:ItemBrowserCell
        {
        fatalError("This should have been overridden in a subclass")
        }
        
    internal init(shortName:String = "",container:SymbolContainer = .nothing)
        {
        self.shortName = shortName
        self.container = container
        self.id = UUID()
        super.init()
        }
    
    internal init(name:Name,container:SymbolContainer = .nothing)
        {
        self.shortName = name.last
        self.container = container
        self.id = UUID()
        super.init()
        }

    public func menu(for:NSEvent,in:Int,on:Elemental) -> NSMenu?
        {
        return(nil)
        }
        
    public var isLeaf: Bool
        {
        return(true)
        }
    
    public var title: String
        {
        return(self.shortName)
        }
    
    public var icon: NSImage
        {
        return(NSImage(named:"IconClass64")!)
        }
        
    public var childCount: Int
        {
        return(0)
        }
    
    public func child(at: Int) -> Elemental
        {
        fatalError()
        }
        
    public var elementals:Elementals
        {
        return([])
        }
        
    public func accept(_ visitor:SymbolVisitor)
        {
        visitor.acceptSymbol(self)
        }
        
    internal func relinkSymbolsUsingIds(symbols:Dictionary<UUID,Symbol>)
        {
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
        
    internal override func lookup(name:Name) -> SymbolSet?
        {
        fatalError("\(#function) should have been overridden in a subclass of Symbol")
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
        self.container.encode(with:coder)
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
        self.container = SymbolContainer(with:coder)
        self.memoryAddress = coder.decodeObject(forKey:"memoryAddress") as! MemoryAddress
        }
    }

extension UUID
    {
    static let zero = Self(uuidString: "00000000-0000-0000-0000-000000000000")!
    }
