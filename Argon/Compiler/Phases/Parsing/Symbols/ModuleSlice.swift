//
//  ModuleSlice.swift
//  Argon
//
//  Created by Vincent Coetzee on 05/06/2020.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

internal class ModuleSlice:Symbol
    {
    private var symbols:[String:SymbolSet] = [:]
    internal var module:Module
    
    internal override func pushScope()
        {
        super.push()
        }
    
    internal override func popScope()
        {
        super.pop()
        }
        
    internal override func addSymbol(_ symbol: Symbol)
        {
        let name = symbol.shortName
        if let set = self.symbols[name]
            {
            set.append(symbol)
            }
        else
            {
            self.symbols[name] = SymbolSet(symbol)
            }
        }
    
    internal override func lookup(name: Name) -> SymbolSet?
        {
        if name.count == 0
            {
            return(SymbolSet(self))
            }
        else if name.count == 1
            {
            if self.shortName == name.first
                {
                return(SymbolSet(self))
                }
            return(nil as SymbolSet?)
            }
        else
            {
            if let set = self.symbols[name.first]
                {
                return(set.first.lookup(name: name.withoutFirst()))
                }
            return(nil as SymbolSet?)
            }
        }
    
    internal override func lookup(shortName: String) -> SymbolSet?
        {
        if let set = self.symbols[shortName]
            {
            return(set)
            }
        return(nil as SymbolSet?)
        }
        
    internal init(shortName:String,module:Module)
        {
        self.module = module
        super.init(shortName: shortName)
        }
    
    internal required init(_ parser: Parser)
        {
        fatalError("init(_:) has not been implemented")
        }
    
    internal required init()
        {
        self.module = Module(shortName:"")
        super.init()
        }
        
    internal override func populate(from parser:Parser)
        {
        }
    }
