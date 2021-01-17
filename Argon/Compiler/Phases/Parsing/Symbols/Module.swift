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
    private var moduleKey = UUID()
    private var versionKey:SemanticVersionNumber = .one
    
    public override var isModuleLevelSymbol:Bool
        {
        return(true)
        }
        
    internal override func addSymbol(_ symbol:Symbol)
        {
        super.addSymbol(symbol)
        symbol.symbolAdded(to: self)
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
    }


public class ModuleClass:Class
    {
    public static func ==(lhs:ModuleClass,rhs:Class) -> Bool
        {
        return(Swift.type(of:rhs)==Swift.type(of:lhs) && rhs.shortName == lhs.shortName)
        }
    }
