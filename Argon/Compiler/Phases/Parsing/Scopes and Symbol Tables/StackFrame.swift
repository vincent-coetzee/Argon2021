//
//  StackFrame.swift
//  Argon
//
//  Created by Vincent Coetzee on 2021/03/13.
//

import Foundation

public class StackFrame:Scope,Equatable
    {
    public static func == (lhs: StackFrame, rhs: StackFrame) -> Bool
        {
        return(lhs.id == rhs.id)
        }
        
    public var rootSymbol:Symbol
        {
        return(self.container.rootSymbol)
        }
        
    public let id = UUID()
    public var container:SymbolContainer = .nothing
    private var symbols = SymbolDictionary()
    
    public func asSymbolContainer() -> SymbolContainer
        {
        return(.stackFrame(self))
        }
    
    public func lookup(shortName: String) -> SymbolSet?
        {
        return(symbols.lookup(shortName:shortName))
        }
        
    public func lookup(name: Name) -> SymbolSet?
        {
        if name.isAnchored
            {
            return(self.container.rootSymbol.lookup(name:name))
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
        
    public func addTypeSymbol(_ symbol:TypeSymbol)
        {
        self.symbols.addSymbol(symbol)
        }
        
    public func addLocalVariable(_ local:LocalVariable)
        {
        self.symbols.addSymbol(local)
        }
        
    public func removeSymbol(_ symbol:Symbol)
        {
        self.symbols[symbol.shortName] = self.symbols[symbol.shortName]?.withoutSymbol(symbol)
        }
    }
