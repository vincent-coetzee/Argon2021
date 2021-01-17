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
        self.push()
        }
        
    internal func popScope()
        {
        self.pop()
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
    }
