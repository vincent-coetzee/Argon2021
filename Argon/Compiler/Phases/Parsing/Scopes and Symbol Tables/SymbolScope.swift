//
//  SymbolScope.swift
//  Argon
//
//  Created by Vincent Coetzee on 20/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class SymbolScope:Scope
    {
    private var symbols:[String:SymbolSet] = [:]
    internal var index: Int = Argon.nextIndex()
    internal var parentScope:Scope?
    
    internal func pushScope()
        {
        self.pushScope()
        }
        
    internal func popScope()
        {
        self.popScope()
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
        
     public func lookupMethod(shortName:String) -> Method?
        {
        if let set = self.lookup(shortName:shortName)
            {
            for symbol in set.symbols
                {
                if symbol is Method
                    {
                    return(symbol as? Method)
                    }
                }
            }
        return(nil)
        }
        
    internal func addSymbol(_ symbol:Symbol)
        {
        symbol.definingScope = self
        if symbol.isModuleLevelSymbol
            {
            self.parentScope?.addSymbol(symbol)
            return
            }
        if let set = self.symbols[symbol.shortName]
            {
            set.append(symbol)
            }
        else
            {
            self.symbols[symbol.shortName] = SymbolSet(symbol)
            }
        }
    
    internal func addStatement(_ statement: Statement)
        {
        fatalError("Attempt to addStatement")
        }
        
    internal func lookup(shortName: String) -> SymbolSet?
        {
        if let set = self.symbols[shortName]
            {
            return(set)
            }
        return(self.parentScope?.lookup(shortName:shortName))
        }
        
    internal func lookup(name:Name) -> SymbolSet?
        {
        if let item = self.symbols[name.first]?.first
            {
            return(item.lookup(name:name.withoutFirst()))
            }
        return(self.parentScope?.lookup(name:name))
        }
    }
