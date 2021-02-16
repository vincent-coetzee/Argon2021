//
//  RootScope.swift
//  EOS
//
//  Created by Vincent Coetzee on 07/05/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class RootScope:Scope
    {
    private var symbols:[String:Symbol] = [:]
    internal var parentScope: Scope? = nil
    internal var index: Int = Argon.nextIndex()
    
    internal func pushScope()
        {
        self.push()
        }
        
    internal func popScope()
        {
        self.pop()
        }
        
    internal func lookup(shortName: String) -> SymbolSet?
        {
        if let symbol = self.symbols[shortName]
            {
            return(SymbolSet(symbol))
            }
        return(nil as SymbolSet?)
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
        
    internal func addSymbol(_ symbol: Symbol)
        {
        self.symbols[symbol.shortName] = symbol
        }
        
    internal func addStatement(_ statement:Statement)
        {
        fatalError("Attempt to add a statement \(statement) to non statement bearing construct")
        }
    }
