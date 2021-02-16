//
//  LocalScope.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 28/02/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class LocalScope:Scope
    {
    internal var parentScope:Scope?
    internal var index:Int = Argon.nextIndex()
    private var symbols:[String:SymbolSet] = [:]
    
    internal func pushScope()
        {
        self.push()
        }
        
    internal func popScope()
        {
        self.pop()
        }
        
    internal func addStatement(_ statement:Statement)
        {
        fatalError("Attempt to add statement \(statement) to no statement bearing object")
        }
        
    internal func addSymbol(_ symbol: Symbol)
        {
        symbol.definingScope = self
        if let set = self.symbols[symbol.shortName]
            {
            set.append(symbol)
            }
        else
            {
            self.symbols[symbol.shortName] = SymbolSet(symbol)
            }
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
        
    internal func lookup(shortName:String) -> SymbolSet?
        {
        if let set = self.symbols[shortName]
            {
            return(set)
            }
        return(self.parentScope?.lookup(shortName: shortName))
        }
    }
