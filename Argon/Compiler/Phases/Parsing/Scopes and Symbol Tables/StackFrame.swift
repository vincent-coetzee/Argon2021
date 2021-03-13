//
//  StackFrame.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/13.
//

import Foundation

public class StackFrame:SymbolTable
    {
    public let id = UUID()
    public var container:SymbolContainer = .nothing
    private var symbols = SymbolDictionary()
    
    public func lookup(name: Name) -> SymbolSet?
        {
        if name.isAnchored
            {
            return(self.container.topSymbolTable.lookup(name:name))
            }
        if let set = self.symbols[name.first]
            {
            return(set.lookup(name:name.withoutFirst()))
            }
        return(nil)
        }
    
    public func addSymbol(_ symbol: Symbol)
        {
        self.symbols.addSymbol(symbol)
        }
    }
