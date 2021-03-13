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
    internal var container:SymbolContainer
    internal var index:Int = Argon.nextIndex()
    private var symbols:[String:SymbolSet] = [:]
            
    init(container:SymbolContainer)
        {
        self.container = container
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
        let set = self.lookup(shortName:shortName)
        if set.isEmpty
            {
            return(nil)
            }
        if let method = set.method
            {
            return(method)
            }
        return(nil)
        }
        
    internal func lookup(shortName:String) -> SymbolSet
        {
        if let set = self.symbols[shortName]
            {
            return(set)
            }
        return(self.container.lookup(shortName: shortName))
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
