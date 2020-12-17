//
//  ContainerSymbol.swift
//  CobaltX
//
//  Created by Vincent Coetzee on 2020/02/26.
//  Copyright © 2020 Vincent Coetzee. All rights reserved.
//

import Foundation

public class SymbolContainer:Symbol
    {
    public override var isScope:Bool
        {
        return(true)
        }
        
    private var symbols:[String:SymbolSet] = [:]
        
    internal override func addSymbol(_ symbol:Symbol)
        {
        if symbol.isModuleLevelSymbol && !(self is Module)
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
        symbol.parent = self
        }
        
    internal override func lookup(shortName:String) -> SymbolSet?
        {
        if shortName == self.shortName
            {
            return(SymbolSet(self))
            }
        if let set = self.symbols[shortName]
            {
            return(set)
            }
        return(self.parentScope?.lookup(shortName: shortName))
        }
    }
