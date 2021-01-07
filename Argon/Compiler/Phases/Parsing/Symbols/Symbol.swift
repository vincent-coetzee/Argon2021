//
//  Symbol.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class Symbol:ParseNode,Equatable,Hashable
    {
    internal var shortName:String
    internal var wasDeclaredForward = false
    internal var references:[SourceReference] = []
    internal var accessLevel = AccessModifier.public
    internal var parent:Symbol?
        
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
        super.init()
        }
    
    internal init(name:Name,parent:Symbol? = nil)
        {
        self.shortName = name.first
        self.parent = parent
        super.init()
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
        
    internal func generateIntermediateCode(in:Module,codeHolder:CodeHolder,into buffer:ThreeAddressInstructionBuffer,using:Compiler) throws
        {
        
        }
    internal func  sourceFileElements() -> [SourceFileElement]
        {
        fatalError("This should be overridden")
        }
    }
